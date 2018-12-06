const fs = require('fs')

const match = (s1, s2) => s1.toLowerCase() == s2.toLowerCase() && s1 !== s2

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
      index++
    }
  }
}

// const data = fs.readFileSync('sample.txt', 'utf8')
const data = fs.readFileSync('input.txt', 'utf8')

const m = {}

for (let i = 0; i < data.length; i++) {
  m[data[i].toLowerCase()] = true
}

const strList = Object.keys(m).map((ch) => {
  const regex = new RegExp(`([${ch.toUpperCase()}${ch}])`, 'g')
  return data.replace(regex, '')
})

let min = 99999999

for (let i = 0; i < strList.length; i++) {
  str = strList[i]

  min = Math.min(produce(str).length, min)
}

console.log(min)