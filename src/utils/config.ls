require! {
    fs
}

jsonStr = fs.readFileSync '../config.json'
jsonObject = JSON.parse jsonStr

module.exports = jsonObject
