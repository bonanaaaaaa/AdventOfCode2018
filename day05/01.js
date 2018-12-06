const fs = require('fs')

function match(s1, s2) {
  return s1.toLowerCase() == s2.toLowerCase() && s1 !== s2
}

function produce(str, index = 0) {
  while (true) {
    if (str.length - 1 === index + 1) {
      return str
    }

    if (match(str.charAt(index), str.charAt(index + 1))) {
      const front = str.slice(0, index)
      str = front + str.slice(index + 2)

      index = Math.max(0, index - 1)
    } else {
      index += 1
    }
  }
}

// const data = fs.readFileSync('sample.txt', 'utf8')
const data = fs.readFileSync('input.txt', 'utf8')

const ans = produce(data).length
console.log(ans)