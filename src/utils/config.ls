require! {
    fs
}

jsonStr = fs.readFileSync '../config.json'
jsonObject = JSON.parse jsonStr
jsonObject.mongoUrl = "mongodb://#{jsonObject.host}:#{jsonObject.mongoPort}/#{jsonObject.mongoName}"

module.exports = jsonObject
