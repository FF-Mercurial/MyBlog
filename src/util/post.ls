function decode fileContent
    regex = /^@/mg
    postObj = {}
    while m = regex.exec fileContent
        atIndex = m.index
        if brIndex
            value = trim fileContent.substring brIndex + 1, atIndex - 1
            postObj[key] = value
        brIndex = fileContent.indexOf '\n', atIndex
        key = trim fileContent.substring atIndex + 1, brIndex
    value = trim fileContent.substring brIndex + 1, fileContent.length - 1
    postObj[key] = value
    postObj.tags = postObj.tags.split /,\s*/
    postObj

function encode postObj
    fileContent = ''
    fileContent += '@title\n    ' + postObj.title + '\n'
    fileContent += '@tags\n    ' + postObj.tags.join(', ') + '\n'
    fileContent += '@summary\n\n' + postObj.summary + '\n\n'
    fileContent += '@content\n\n' + postObj.content

function trim str
    lIndex = 0
    rIndex = str.length - 1
    regex = /\s/
    while lIndex <= rIndex and regex.test str[lIndex]
        lIndex++
    while lIndex <= rIndex and regex.test str[rIndex]
        rIndex--
    str.substring lIndex, rIndex + 1

module.exports =
    decode: decode
    encode: encode
