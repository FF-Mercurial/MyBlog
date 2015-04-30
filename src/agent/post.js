// Generated by LiveScript 1.3.1
(function(){
  function decode(fileContent){
    var regex, postObj, m, atIndex, value, brIndex, key;
    regex = /^@/mg;
    postObj = {};
    while (m = regex.exec(fileContent)) {
      atIndex = m.index;
      if (brIndex) {
        value = trim(fileContent.substring(brIndex + 1, atIndex - 1));
        postObj[key] = value;
      }
      brIndex = fileContent.indexOf('\n', atIndex);
      key = trim(fileContent.substring(atIndex + 1, brIndex));
    }
    value = trim(fileContent.substring(brIndex + 1, fileContent.length - 1));
    postObj[key] = value;
    postObj.tags = postObj.tags.split(/,\s*/);
    return postObj;
  }
  function encode(postObj){
    var fileContent;
    fileContent = '';
    fileContent += '@title\n    ' + postObj.title + '\n';
    fileContent += '@tags\n    ' + postObj.tags.join(', ') + '\n';
    fileContent += '@summary\n\n' + postObj.summary + '\n\n';
    return fileContent += '@content\n\n' + postObj.content;
  }
  function trim(str){
    var lIndex, rIndex, regex;
    lIndex = 0;
    rIndex = str.length - 1;
    regex = /\s/;
    while (lIndex <= rIndex && regex.test(str[lIndex])) {
      lIndex++;
    }
    while (lIndex <= rIndex && regex.test(str[rIndex])) {
      rIndex--;
    }
    return str.substring(lIndex, rIndex + 1);
  }
  module.exports = {
    decode: decode,
    encode: encode
  };
}).call(this);
