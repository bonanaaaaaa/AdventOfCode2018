const fs = require('fs')

function match(s1, s2) {
  return s1.toLowerCase() == s2.toLowerCase() && s1 !== s2
}

function produce(str) {
  const l = str.length

  if (l === 0) {
    return ''
  } else if (l === 1) {
    return str
  } else {
    const half = Math.round(l / 2)

    const left = str.slice(0, half)
    const right = str.slice(half)

    return merge(produce(left), produce(right))
  }
}

function merge(left, right) {
  if (left === '' && right === '') {
    return ''
  } else if (left === '') {
    return right
  } else if (right === '') {
    return left
  } else if (match(left.charAt(left.length - 1), right.charAt(0))) {
    return merge(left.slice(0, left.length - 1), right.slice(1))
  } else {
    return left + right
  }
}

function run() {
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
}

run()