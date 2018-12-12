// const generations = 50000000000;
// const generations = 20;
const generations = 50000;
let count = -3;

const initialState =
  "...##.######...#.##.#...#...##.####..###.#.##.#.##...##..#...##.#..##....##...........#.#.#..###.#";

const map = {
  ".###.": "#",
  "#.##.": ".",
  ".#.##": "#",
  "...##": ".",
  "###.#": "#",
  "##.##": ".",
  ".....": ".",
  "#..#.": "#",
  "..#..": "#",
  "#.###": "#",
  "##.#.": ".",
  "..#.#": "#",
  "#.#.#": "#",
  ".##.#": "#",
  ".#..#": "#",
  "#..##": "#",
  "##..#": "#",
  "#...#": ".",
  "...#.": "#",
  "#####": ".",
  "###..": "#",
  "#.#..": ".",
  "....#": ".",
  ".####": "#",
  "..###": ".",
  "..##.": "#",
  ".##..": ".",
  "#....": ".",
  "####.": "#",
  ".#.#.": ".",
  ".#...": "#",
  "##...": "#"
};

const mem = {};

calculate();

function calculate() {
  const head = "..";
  let state = initialState;
  for (let i = 0; i < generations; i++) {
    state = generateNewState(head + state);
    if (mem[state]) {
      state = mem[state];
    } else {
      // console.log(i, state.length);
      // state = head + state;
      // state = generateNewState(state);
      // console.log(state);
      // console.log(count);
      const newState = cal(state);
      mem[state] = newState;
      state = newState;
    }
  }
  const ans = calculateStateValue(state);
  console.log(Object.keys(mem).length);
  console.log(ans);
}

function calculateStateValue(state) {
  let sum = 0;
  let start = count;

  const arr = state.split("");

  for (let i = 0; i < arr.length; i++) {
    if (arr[i] === "#") {
      sum += start;
    }
    start++;
  }
  return sum;
}

function cal(state) {
  let str = "";
  let st = state;

  while (true) {
    if (st === ".....") {
      str += ".";
      break;
    }
    if (st.length < 5) {
      st += ".";
      continue;
    }

    const pattern = st.slice(0, 5);
    const s = map[pattern] || ".";
    st = st.slice(1);
    str += s;
  }

  return str;
}

function generateNewState(state) {
  let st = state;

  // console.log("=========");
  // console.log(st);
  while (true) {
    const pattern = st.slice(0, 5);
    // console.log(pattern);
    if (pattern !== ".....") {
      return st;
    }
    count++;
    st = st.slice(1);
  }
}
