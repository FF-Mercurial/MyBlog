exports.union = (a, b)!->
    res = {}
    for key in a
        union[key] = a[key]
    for key in b
        union[key] = b[key]
