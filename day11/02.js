let mem = {};

const gridSize = 300;
const serial = 7989;

for (let x = 1; x <= gridSize; x++) {
  for (let y = 1; y <= gridSize; y++) {
    const power = calculatePower({ x, y });
    mem[`${x},${y},1,1`] = power;
  }
}

// console.log(mem);

let maxPower = -9999999;
let maxPos = null;

for (let s = 2; s <= 3; s++) {
  for (let x = 1; x <= gridSize - s + 1; x++) {
    for (let y = 1; y <= gridSize - s + 1; y++) {
      const power = calculatePowerWithSize({
        x,
        y,
        xSize: x + s - 1,
        ySize: y + s - 1
      });

      if (power > maxPower) {
        maxPower = power;
        maxPos = `${x},${y},${s}`;
      }
    }
  }
}

console.log(maxPower);
console.log(maxPos);

function calculatePower(pos) {
  const rackId = pos.x + 10;
  const powerStart = (rackId * pos.y + serial) * rackId;
  return (Math.floor(powerStart, 100) % 10) - 5;
}

function calculatePowerWithSize({ x, y, xSize, ySize }) {
  const minX = x;
  const maxX = x + xSize - 1;
  const minY = y;
  const maxY = y + ySize - 1;

  // console.log({ x, y, xSize, ySize });

  const key = `${x},${y},${xSize},${ySize}`;

  if (mem[key]) {
    return mem[key];
  }

  if (minX == maxX || minY == maxY) {
    return 0;
  }

  const midX = Math.ceil((minX + maxX) / 2);
  const midY = Math.ceil((minY + maxY) / 2);
  const midSizeX = Math.ceil(xSize / 2);
  const midSizeY = Math.ceil(ySize / 2);

  // const arr = [];

  const arr = [
    {
      x,
      y,
      xSize: midSizeX,
      ySize: midSizeY
    },
    {
      x: midX,
      y: midY,
      xSize: xSize - midSizeX,
      ySize: ySize - midSizeY
    },
    {
      x,
      y: midY,
      xSize: midSizeX,
      ySize: ySize - midSizeY
    },
    {
      x: midX,
      y,
      xSize: xSize - midSizeX,
      ySize: midSizeY
    }
  ];

  const ans = arr.reduce(function(sum, a) {
    return sum + calculatePowerWithSize(a);
  }, 0);

  mem[key] = ans;

  return ans;
}
