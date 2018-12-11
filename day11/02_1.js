let mem = {};

const gridSize = 300;
const serial = 7989;

for (let x = 1; x <= gridSize; x++) {
  for (let y = 1; y <= gridSize; y++) {
    const power = calculatePower({ x, y });
    mem[`${x},${y},1`] = power;
  }
}

// console.log(mem);

let maxPower = -9999999;
let maxPos = null;

for (let s = 2; s <= 300; s++) {
  for (let x = 1; x <= gridSize - s + 1; x++) {
    for (let y = 1; y <= gridSize - s + 1; y++) {
      const power = calculatePowerWithSize({
        x,
        y,
        size: s
      });

      if (power > maxPower) {
        maxPower = power;
        maxPos = `${x},${y},${s}`;
      }
    }
  }
  console.log("Done for size:", s);
  console.log(maxPower);
  console.log(maxPos);
}

console.log(maxPower);
console.log(maxPos);

function calculatePower({ x, y }) {
  const rackId = x + 10;
  const powerStart = (rackId * y + serial) * rackId;
  return (Math.floor(powerStart / 100) % 10) - 5;
}

function calculatePowerWithSize({ x, y, size }) {
  const keys = generateKeys({ x, y, size });

  // console.log({ x, y, size });
  // console.log(keys);

  const sum = keys.reduce(function(power, k) {
    return power + (mem[k] || 0);
  }, 0);

  const key = `${x},${y},${size}`;
  mem[key] = sum;
  return sum;
}

function generateKeys({ x, y, size }) {
  const minX = x;
  const minY = y;
  const maxX = x + size - 1;
  const maxY = y + size - 1;

  const arr = [];

  for (let xi = minX; xi <= maxX; xi++) {
    arr.push(`${xi},${maxY},1`);
  }
  for (let yi = minY; yi <= maxY - 1; yi++) {
    arr.push(`${maxX},${yi},1`);
  }
  arr.push(`${x},${y},${size - 1}`);

  return arr;
}
