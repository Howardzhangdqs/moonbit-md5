pub fn md5(str : String, ~bit : Int = 16) -> String {
  fn rotate_left(lValue : Int, iShiftBits : Int) -> Int {
    lValue.lsl(iShiftBits).lor(lValue.lsr(32 - iShiftBits))
  }

  fn add_unsigned(lX : Int, lY : Int) -> Int {
    let lX8 = lX.land(0x80000000)
    let lY8 = lY.land(0x80000000)
    let lX4 = lX.land(0x40000000)
    let lY4 = lY.land(0x40000000)
    let lResult = lX.land(0x3FFFFFFF) + lY.land(0x3FFFFFFF)
    if lX4.land(lY4) != 0 {
      lResult.lxor(0x80000000).lxor(lX8).lxor(lY8)
    } else if lX4.lor(lY4) != 0 {
      if lResult.land(0x40000000) != 0 {
        lResult.lxor(0xC0000000).lxor(lX8).lxor(lY8)
      } else {
        lResult.lxor(0x40000000).lxor(lX8).lxor(lY8)
      }
    } else {
      lResult.lxor(lX8).lxor(lY8)
    }
  }

  fn f(x : Int, y : Int, z : Int) -> Int {
    x.land(y).lor(x.lnot().land(z))
  }

  fn g(x : Int, y : Int, z : Int) -> Int {
    x.land(z).lor(y.land(z.lnot()))
  }

  fn h(x : Int, y : Int, z : Int) -> Int {
    x.lxor(y).lxor(z)
  }

  fn i(x : Int, y : Int, z : Int) -> Int {
    y.lxor(x.lor(z.lnot()))
  }

  fn ff(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, ac : Int) -> Int {
    let t = add_unsigned(a, add_unsigned(add_unsigned(f(b, c, d), x), ac))
    add_unsigned(rotate_left(t, s), b)
  }

  fn gg(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, ac : Int) -> Int {
    let t = add_unsigned(a, add_unsigned(add_unsigned(g(b, c, d), x), ac))
    add_unsigned(rotate_left(t, s), b)
  }

  fn hh(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, ac : Int) -> Int {
    let t = add_unsigned(a, add_unsigned(add_unsigned(h(b, c, d), x), ac))
    add_unsigned(rotate_left(t, s), b)
  }

  fn ii(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, ac : Int) -> Int {
    let t = add_unsigned(a, add_unsigned(add_unsigned(i(b, c, d), x), ac))
    add_unsigned(rotate_left(t, s), b)
  }

  fn convert_to_wordarray(sMessage : String) -> Array[Int] {
    let mut lWordCount : Int = 0
    let lMessageLength = sMessage.length()
    let lNumberOfWords_temp1 = lMessageLength + 8
    let lNumberOfWords = ((lNumberOfWords_temp1 - lNumberOfWords_temp1 % 64) / 64 +
      1) * 16
    let lWordArray = []
    while lWordArray.length() < lNumberOfWords {
      lWordArray.push(0)
    }
    let mut lBytePosition = 0
    let mut lByteCount = 0
    while lByteCount < lMessageLength {
      lWordCount = (lByteCount - lByteCount % 4) / 4
      lBytePosition = lByteCount % 4 * 8
      lWordArray[lWordCount] = lWordArray[lWordCount].lor(
        sMessage[lByteCount].to_int().lsl(lBytePosition),
      )
      lByteCount += 1
    }
    lWordCount = (lByteCount - lByteCount % 4) / 4
    lBytePosition = lByteCount % 4 * 8
    lWordArray[lWordCount] = lWordArray[lWordCount].lor(
      (0x80).lsl(lBytePosition),
    )
    lWordArray[lNumberOfWords - 2] = lMessageLength.lsl(3)
    lWordArray[lNumberOfWords - 1] = lMessageLength.lsr(29)
    lWordArray
  }

  fn int_to_hex(_val : Int) -> String {
    // val转为16进制
    let hex = "0123456789abcdef"
    let mut str = ""
    let mut i = 0
    let mut val = _val
    while i < 4 {
      let t1 = hex[val % 16]
      val /= 16
      str = "\(t1)\(str)"
      i += 1
    }
    str
  }

  fn word_to_hex(lValue : Int) -> String {
    let mut word_to_hex_value = ""
    let mut word_to_hex_value_temp = ""
    let mut lByte = 0
    let mut lCount = 0
    while lCount <= 3 {
      lByte = lValue.lsr(lCount * 8).land(255)
      let t = int_to_hex(lByte)
      word_to_hex_value_temp = "0\(t)"
      let tl = word_to_hex_value_temp.length()
      let tchar1 = word_to_hex_value_temp[tl - 2]
      let tchar2 = word_to_hex_value_temp[tl - 1]
      word_to_hex_value = "\(word_to_hex_value)\(tchar1)\(tchar2)"
      lCount += 1
    }
    word_to_hex_value
  }

  let mut x : Array[Int] = []
  let mut k = 0
  let mut aa = 0
  let mut bb = 0
  let mut cc = 0
  let mut dd = 0
  let mut a = 0x67452301
  let mut b = 0xEFCDAB89
  let mut c = 0x98BADCFE
  let mut d = 0x10325476
  let s11 = 7
  let s12 = 12
  let s13 = 17
  let s14 = 22
  let s21 = 5
  let s22 = 9
  let s23 = 14
  let s24 = 20
  let s31 = 4
  let s32 = 11
  let s33 = 16
  let s34 = 23
  let s41 = 6
  let s42 = 10
  let s43 = 15
  let s44 = 21
  x = convert_to_wordarray(str)
  let xlength = x.length()
  while k < xlength {
    aa = a
    bb = b
    cc = c
    dd = d
    a = ff(a, b, c, d, x[k + 0], s11, 0xd76aa478)
    d = ff(d, a, b, c, x[k + 1], s12, 0xe8c7b756)
    c = ff(c, d, a, b, x[k + 2], s13, 0x242070db)
    b = ff(b, c, d, a, x[k + 3], s14, 0xc1bdceee)
    a = ff(a, b, c, d, x[k + 4], s11, 0xf57c0faf)
    d = ff(d, a, b, c, x[k + 5], s12, 0x4787c62a)
    c = ff(c, d, a, b, x[k + 6], s13, 0xa8304613)
    b = ff(b, c, d, a, x[k + 7], s14, 0xfd469501)
    a = ff(a, b, c, d, x[k + 8], s11, 0x698098d8)
    d = ff(d, a, b, c, x[k + 9], s12, 0x8b44f7af)
    c = ff(c, d, a, b, x[k + 10], s13, 0xffff5bb1)
    b = ff(b, c, d, a, x[k + 11], s14, 0x895cd7be)
    a = ff(a, b, c, d, x[k + 12], s11, 0x6b901122)
    d = ff(d, a, b, c, x[k + 13], s12, 0xfd987193)
    c = ff(c, d, a, b, x[k + 14], s13, 0xa679438e)
    b = ff(b, c, d, a, x[k + 15], s14, 0x49b40821)
    a = gg(a, b, c, d, x[k + 1], s21, 0xf61e2562)
    d = gg(d, a, b, c, x[k + 6], s22, 0xc040b340)
    c = gg(c, d, a, b, x[k + 11], s23, 0x265e5a51)
    b = gg(b, c, d, a, x[k + 0], s24, 0xe9b6c7aa)
    a = gg(a, b, c, d, x[k + 5], s21, 0xd62f105d)
    d = gg(d, a, b, c, x[k + 10], s22, 0x2441453)
    c = gg(c, d, a, b, x[k + 15], s23, 0xd8a1e681)
    b = gg(b, c, d, a, x[k + 4], s24, 0xe7d3fbc8)
    a = gg(a, b, c, d, x[k + 9], s21, 0x21e1cde6)
    d = gg(d, a, b, c, x[k + 14], s22, 0xc33707d6)
    c = gg(c, d, a, b, x[k + 3], s23, 0xf4d50d87)
    b = gg(b, c, d, a, x[k + 8], s24, 0x455a14ed)
    a = gg(a, b, c, d, x[k + 13], s21, 0xa9e3e905)
    d = gg(d, a, b, c, x[k + 2], s22, 0xfcefa3f8)
    c = gg(c, d, a, b, x[k + 7], s23, 0x676f02d9)
    b = gg(b, c, d, a, x[k + 12], s24, 0x8d2a4c8a)
    a = hh(a, b, c, d, x[k + 5], s31, 0xfffa3942)
    d = hh(d, a, b, c, x[k + 8], s32, 0x8771f681)
    c = hh(c, d, a, b, x[k + 11], s33, 0x6d9d6122)
    b = hh(b, c, d, a, x[k + 14], s34, 0xfde5380c)
    a = hh(a, b, c, d, x[k + 1], s31, 0xa4beea44)
    d = hh(d, a, b, c, x[k + 4], s32, 0x4bdecfa9)
    c = hh(c, d, a, b, x[k + 7], s33, 0xf6bb4b60)
    b = hh(b, c, d, a, x[k + 10], s34, 0xbebfbc70)
    a = hh(a, b, c, d, x[k + 13], s31, 0x289b7ec6)
    d = hh(d, a, b, c, x[k + 0], s32, 0xeaa127fa)
    c = hh(c, d, a, b, x[k + 3], s33, 0xd4ef3085)
    b = hh(b, c, d, a, x[k + 6], s34, 0x4881d05)
    a = hh(a, b, c, d, x[k + 9], s31, 0xd9d4d039)
    d = hh(d, a, b, c, x[k + 12], s32, 0xe6db99e5)
    c = hh(c, d, a, b, x[k + 15], s33, 0x1fa27cf8)
    b = hh(b, c, d, a, x[k + 2], s34, 0xc4ac5665)
    a = ii(a, b, c, d, x[k + 0], s41, 0xf4292244)
    d = ii(d, a, b, c, x[k + 7], s42, 0x432aff97)
    c = ii(c, d, a, b, x[k + 14], s43, 0xab9423a7)
    b = ii(b, c, d, a, x[k + 5], s44, 0xfc93a039)
    a = ii(a, b, c, d, x[k + 12], s41, 0x655b59c3)
    d = ii(d, a, b, c, x[k + 3], s42, 0x8f0ccc92)
    c = ii(c, d, a, b, x[k + 10], s43, 0xffeff47d)
    b = ii(b, c, d, a, x[k + 1], s44, 0x85845dd1)
    a = ii(a, b, c, d, x[k + 8], s41, 0x6fa87e4f)
    d = ii(d, a, b, c, x[k + 15], s42, 0xfe2ce6e0)
    c = ii(c, d, a, b, x[k + 6], s43, 0xa3014314)
    b = ii(b, c, d, a, x[k + 13], s44, 0x4e0811a1)
    a = ii(a, b, c, d, x[k + 4], s41, 0xf7537e82)
    d = ii(d, a, b, c, x[k + 11], s42, 0xbd3af235)
    c = ii(c, d, a, b, x[k + 2], s43, 0x2ad7d2bb)
    b = ii(b, c, d, a, x[k + 9], s44, 0xeb86d391)
    a = add_unsigned(a, aa)
    b = add_unsigned(b, bb)
    c = add_unsigned(c, cc)
    d = add_unsigned(d, dd)
    k += 16
  }
  if bit == 32 {
    let t = word_to_hex(a)
    let t1 = word_to_hex(b)
    let t2 = word_to_hex(c)
    let t3 = word_to_hex(d)
    return "\(t)\(t1)\(t2)\(t3)"
  } else {
    let t = word_to_hex(b)
    let t1 = word_to_hex(c)
    return "\(t)\(t1)"
  }
}
