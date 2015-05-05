require! {
    fs
}

jsonStr = fs.readFileSync '../config.json'
jsonObject = JSON.parse jsonStr
jsonObject.mongoUrl = "mongodb://localhost:#{jsonObject.mongoPort}/#{jsonObject.mongoName}"

module.exports = jsonObject
