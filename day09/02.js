// const lastScore = 25;
// const playerAmount = 9;
// const lastScore = 1618;
// const playerAmount = 10;
// const lastScore = 1104;
// const playerAmount = 17;
// const lastScore = 71082;
// const playerAmount = 413;
const lastScore = 7108200;
const playerAmount = 413;

function generateId() {
  // Math.random should be unique because of its seeding algorithm.
  // Convert it to base 36 (numbers + letters), and grab the first 9 characters
  // after the decimal.
  return (
    "_" +
    Math.random()
      .toString(36)
      .substr(2, 9)
  );
}

function createObj(value) {
  return {
    id: generateId(),
    beforeId: null,
    afterId: null,
    value
  };
}
const rack = {};

const first = createObj(0);
const second = createObj(1);

first.beforeId = second.id;
first.afterId = second.id;

second.beforeId = first.id;
second.afterId = first.id;

rack[first.id] = first;
rack[second.id] = second;

let currentLength = 2;

const scoreBoard = {};

let currentObj = second;

// let currentPlayer = 1;

for (let i = 2; i <= lastScore; i++) {
  // console.log(
  //   Object.keys(rack)
  //     .map(k => rack[k].value)
  //     .join(",")
  // );

  if (i % 23 === 0) {
    const currentPlayer = i % playerAmount;

    let current = { ...currentObj };
    for (let j = 0; j < 7; j++) {
      current = rack[current.beforeId];
    }
    // console.log(currentPlayer);
    // console.log(i, current.value);
    // console.log("+++++++++++++++++++");
    scoreBoard[currentPlayer] = scoreBoard[currentPlayer]
      ? scoreBoard[currentPlayer] + i + current.value
      : i + current.value;

    const beforeCurrent = rack[current.beforeId];
    const afterCurrent = rack[current.afterId];

    Reflect.deleteProperty(rack, current.id);

    beforeCurrent.afterId = afterCurrent.id;
    afterCurrent.beforeId = beforeCurrent.id;
    rack[beforeCurrent.id] = beforeCurrent;
    rack[afterCurrent.id] = afterCurrent;
    currentObj = afterCurrent;

    // console.log(scoreBoard);
    // console.log("+++++++++++++++++++");
  } else {
    const newObj = createObj(i);
    const beforeOne = rack[currentObj.afterId];
    const afterOne = rack[beforeOne.afterId];
    newObj.beforeId = beforeOne.id;
    newObj.afterId = afterOne.id;
    beforeOne.afterId = newObj.id;
    afterOne.beforeId = newObj.id;
    rack[afterOne.id] = afterOne;
    rack[beforeOne.id] = beforeOne;
    rack[newObj.id] = newObj;
    currentObj = newObj;

    // let current = { ...currentObj };
    // for (let j = 0; j < 10; j++) {
    //   console.log(current);
    //   current = rack[current.beforeId];
    // }
    // console.log("===============");
  }

  // currentPlayer = ((currentPlayer + 1) % playerAmount) + 1;
}

// console.log(scoreBoard);
console.log(Math.max(...Object.values(scoreBoard)));
