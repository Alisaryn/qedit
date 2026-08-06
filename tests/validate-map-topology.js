#!/usr/bin/env node

'use strict';

const fs = require('fs');
const path = require('path');

const EPSILON = 0.001;
const TRIANGLE_SIZE = 36;
const VERTEX_SIZE = 12;

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function pointOnSegment(p, a, b) {
  const cross = (b.x - a.x) * (p.y - a.y) -
    (b.y - a.y) * (p.x - a.x);
  return Math.abs(cross) <= EPSILON &&
    p.x >= Math.min(a.x, b.x) - EPSILON &&
    p.x <= Math.max(a.x, b.x) + EPSILON &&
    p.y >= Math.min(a.y, b.y) - EPSILON &&
    p.y <= Math.max(a.y, b.y) + EPSILON;
}

function pointInPolygon(p, points) {
  let inside = false;
  for (let i = 0, j = points.length - 1; i < points.length; j = i++) {
    if ((points[i].y > p.y) !== (points[j].y > p.y) &&
        p.x < (points[j].x - points[i].x) * (p.y - points[i].y) /
          (points[j].y - points[i].y) + points[i].x) {
      inside = !inside;
    }
  }
  return inside;
}

function orientation(a, b, c) {
  return (b.x - a.x) * (c.y - a.y) -
    (b.y - a.y) * (c.x - a.x);
}

function segmentsIntersect(a1, a2, b1, b2) {
  const d1 = orientation(a1, a2, b1);
  const d2 = orientation(a1, a2, b2);
  const d3 = orientation(b1, b2, a1);
  const d4 = orientation(b1, b2, a2);
  const proper = ((d1 > EPSILON && d2 < -EPSILON) ||
      (d1 < -EPSILON && d2 > EPSILON)) &&
    ((d3 > EPSILON && d4 < -EPSILON) ||
      (d3 < -EPSILON && d4 > EPSILON));
  return proper ||
    (Math.abs(d1) <= EPSILON && pointOnSegment(b1, a1, a2)) ||
    (Math.abs(d2) <= EPSILON && pointOnSegment(b2, a1, a2)) ||
    (Math.abs(d3) <= EPSILON && pointOnSegment(a1, b1, b2)) ||
    (Math.abs(d4) <= EPSILON && pointOnSegment(a2, b1, b2));
}

function polygonStrictlyContains(outer, inner) {
  if (outer.length < 3 || inner.length < 3) return false;
  for (const point of inner) {
    for (let i = 0; i < outer.length; i++) {
      if (pointOnSegment(point, outer[i], outer[(i + 1) % outer.length])) {
        return false;
      }
    }
    if (!pointInPolygon(point, outer)) return false;
  }
  for (let i = 0; i < inner.length; i++) {
    for (let j = 0; j < outer.length; j++) {
      if (segmentsIntersect(
        inner[i], inner[(i + 1) % inner.length],
        outer[j], outer[(j + 1) % outer.length]
      )) return false;
    }
  }
  return true;
}

function polygonArea(points) {
  let area = 0;
  for (let i = 0; i < points.length; i++) {
    const next = points[(i + 1) % points.length];
    area += points[i].x * next.y - next.x * points[i].y;
  }
  return Math.abs(area * 0.5);
}

function selectParents(contours) {
  const areas = contours.map((contour) => polygonArea(contour.points));
  return contours.map((child, childIndex) => {
    let parent = -1;
    let parentArea = Number.POSITIVE_INFINITY;
    for (let candidateIndex = 0; candidateIndex < contours.length; candidateIndex++) {
      const candidate = contours[candidateIndex];
      if (candidateIndex === childIndex ||
          candidate.block !== child.block ||
          candidate.component !== child.component ||
          areas[candidateIndex] <= areas[childIndex] ||
          areas[candidateIndex] >= parentArea) continue;
      if (polygonStrictlyContains(candidate.points, child.points)) {
        parent = candidateIndex;
        parentArea = areas[candidateIndex];
      }
    }
    return parent;
  });
}

class DisjointSet {
  constructor(size) {
    this.parent = Array.from({length: size}, (_, index) => index);
  }

  find(value) {
    let root = value;
    while (this.parent[root] !== root) root = this.parent[root];
    while (this.parent[value] !== value) {
      const next = this.parent[value];
      this.parent[value] = root;
      value = next;
    }
    return root;
  }

  union(a, b) {
    const rootA = this.find(a);
    const rootB = this.find(b);
    if (rootA !== rootB) this.parent[rootB] = rootA;
  }
}

function parseMap(fileName) {
  const data = fs.readFileSync(fileName);
  const fail = (message) => assert(false, `${path.basename(fileName)}: ${message}`);
  const checkRange = (offset, size, label) => {
    if (!Number.isInteger(offset) || offset < 0 || offset + size > data.length) {
      fail(`${label} is outside the file`);
    }
  };
  const u16 = (offset, label) => {
    checkRange(offset, 2, label);
    return data.readUInt16LE(offset);
  };
  const u32 = (offset, label) => {
    checkRange(offset, 4, label);
    return data.readUInt32LE(offset);
  };
  const f32 = (offset, label) => {
    checkRange(offset, 4, label);
    return data.readFloatLE(offset);
  };

  checkRange(data.length - 16, 4, 'REL footer');
  const relocation = u32(data.length - 16, 'REL relocation pointer');
  let table = u32(relocation, 'REL block table pointer');
  const contours = [];
  let block = 0;
  let triangleCount = 0;
  let interiorEdgeCount = 0;

  while (true) {
    const header = u32(table, `block table entry ${block}`);
    if (header === 0) break;
    const vertexOffset = u32(header + 4, `block ${block} vertex pointer`);
    const count = u32(header + 8, `block ${block} triangle count`);
    const triangleOffset = u32(header + 12, `block ${block} triangle pointer`);
    assert(triangleOffset >= vertexOffset &&
      (triangleOffset - vertexOffset) % VERTEX_SIZE === 0,
    `${path.basename(fileName)}: block ${block} has an invalid vertex table`);
    checkRange(triangleOffset, count * TRIANGLE_SIZE, `block ${block} triangles`);

    const vertexCount = (triangleOffset - vertexOffset) / VERTEX_SIZE;
    const vertices = [];
    for (let offset = vertexOffset; offset < triangleOffset; offset += VERTEX_SIZE) {
      vertices.push({
        x: f32(offset, `block ${block} vertex X`),
        y: f32(offset + 8, `block ${block} vertex Z`)
      });
    }

    const components = new DisjointSet(vertexCount);
    const edgeKeys = [];
    for (let triangle = 0; triangle < count; triangle++) {
      const offset = triangleOffset + triangle * TRIANGLE_SIZE;
      const indices = [
        u16(offset, `block ${block} triangle ${triangle}`),
        u16(offset + 2, `block ${block} triangle ${triangle}`),
        u16(offset + 4, `block ${block} triangle ${triangle}`)
      ];
      for (const index of indices) {
        assert(index < vertexCount,
          `${path.basename(fileName)}: block ${block} has vertex index ${index}/${vertexCount}`);
      }
      const flags = u16(offset + 6, `block ${block} flags`);
      const normalY = f32(offset + 12, `block ${block} normal Y`);
      if (((flags & 1) || (flags & 16) || (flags & 64)) && normalY >= 0.2588) {
        triangleCount++;
        components.union(indices[0], indices[1]);
        components.union(indices[1], indices[2]);
        for (let edge = 0; edge < 3; edge++) {
          const a = Math.min(indices[edge], indices[(edge + 1) % 3]);
          const b = Math.max(indices[edge], indices[(edge + 1) % 3]);
          edgeKeys.push(a * 65536 + b);
        }
      }
    }

    edgeKeys.sort((a, b) => a - b);
    const edges = [];
    for (let index = 0; index < edgeKeys.length;) {
      let next = index + 1;
      while (next < edgeKeys.length && edgeKeys[next] === edgeKeys[index]) next++;
      if (next - index === 1) {
        edges.push({
          a: Math.floor(edgeKeys[index] / 65536),
          b: edgeKeys[index] % 65536,
          used: false
        });
      } else {
        interiorEdgeCount++;
      }
      index = next;
    }

    const adjacency = new Map();
    const addAdjacent = (vertex, edge) => {
      if (!adjacency.has(vertex)) adjacency.set(vertex, []);
      adjacency.get(vertex).push(edge);
    };
    edges.forEach((edge, index) => {
      addAdjacent(edge.a, index);
      addAdjacent(edge.b, index);
    });

    for (let seed = 0; seed < edges.length; seed++) {
      if (edges[seed].used) continue;
      const start = edges[seed].a;
      const indices = [start];
      let next = edges[seed].b;
      let closed = false;
      edges[seed].used = true;
      while (true) {
        indices.push(next);
        const current = next;
        if (current === start) {
          closed = true;
          break;
        }
        let found = false;
        for (const edgeIndex of adjacency.get(current) || []) {
          if (edges[edgeIndex].used) continue;
          const edge = edges[edgeIndex];
          next = edge.a === current ? edge.b : edge.a;
          edge.used = true;
          found = true;
          break;
        }
        if (!found) break;
      }
      assert(closed, `${path.basename(fileName)}: block ${block} has an open contour`);
      if (indices.length >= 3) {
        contours.push({
          block,
          component: components.find(start),
          points: indices.map((index) => vertices[index])
        });
      }
    }

    block++;
    table += 24;
  }

  const parents = selectParents(contours);
  let parentCount = 0;
  parents.forEach((parent, child) => {
    if (parent < 0) return;
    parentCount++;
    assert(contours[parent].block === contours[child].block,
      `${path.basename(fileName)}: cross-block parent`);
    assert(contours[parent].component === contours[child].component,
      `${path.basename(fileName)}: cross-component parent`);
    assert(polygonStrictlyContains(contours[parent].points, contours[child].points),
      `${path.basename(fileName)}: invalid contour containment`);
  });

  return {blocks: block, triangles: triangleCount, contours: contours.length,
    parents: parentCount, interiorEdges: interiorEdgeCount};
}

function validateSyntheticCases() {
  const square = [{x: 0, y: 0}, {x: 10, y: 0}, {x: 10, y: 10}, {x: 0, y: 10}];
  const hole = [{x: 2, y: 2}, {x: 4, y: 2}, {x: 4, y: 4}, {x: 2, y: 4}];
  const overlap = [{x: 8, y: 2}, {x: 12, y: 2}, {x: 12, y: 4}, {x: 8, y: 4}];
  const touching = [{x: 0, y: 2}, {x: 2, y: 2}, {x: 2, y: 4}, {x: 0, y: 4}];
  const concave = [
    {x: 0, y: 0}, {x: 6, y: 0}, {x: 6, y: 6}, {x: 4, y: 6},
    {x: 4, y: 2}, {x: 2, y: 2}, {x: 2, y: 6}, {x: 0, y: 6}
  ];
  const crossingConcavity = [{x: 1, y: 5}, {x: 5, y: 5}, {x: 3, y: 1}];

  assert(polygonStrictlyContains(square, hole), 'synthetic true containment failed');
  assert(!polygonStrictlyContains(square, overlap), 'partial overlap was accepted');
  assert(!polygonStrictlyContains(square, touching), 'boundary touching was accepted');
  assert(!polygonStrictlyContains(concave, crossingConcavity),
    'an edge crossing a concavity was accepted');

  const sameSurface = selectParents([
    {block: 0, component: 0, points: square},
    {block: 0, component: 0, points: hole}
  ]);
  assert(sameSurface[1] === 0, 'valid same-surface hole was rejected');
  const differentBlock = selectParents([
    {block: 0, component: 0, points: square},
    {block: 1, component: 0, points: hole}
  ]);
  assert(differentBlock[1] === -1, 'cross-block parent was accepted');
  const differentComponent = selectParents([
    {block: 0, component: 0, points: square},
    {block: 0, component: 1, points: hole}
  ]);
  assert(differentComponent[1] === -1, 'cross-component parent was accepted');
}

function main() {
  validateSyntheticCases();
  const mapDirectory = path.resolve(__dirname, '..', 'map');
  const files = fs.readdirSync(mapDirectory)
    .filter((name) => /c\.rel$/i.test(name))
    .sort();
  assert(files.length > 0, 'no map collision resources found');

  const totals = {blocks: 0, triangles: 0, contours: 0, parents: 0, interiorEdges: 0};
  for (const name of files) {
    const result = parseMap(path.join(mapDirectory, name));
    for (const key of Object.keys(totals)) totals[key] += result[key];
  }
  process.stdout.write(
    `Validated ${files.length} maps: ${totals.blocks} blocks, ` +
    `${totals.triangles} floor triangles, ${totals.contours} closed contours, ` +
    `${totals.parents} contained holes, ${totals.interiorEdges} interior edges.\n`
  );
}

main();
