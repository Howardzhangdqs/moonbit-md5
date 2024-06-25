test "md5 1" {
  if md5("good") != "723bb39381c7379a" {
    return Err("md5(\"good\") != \"723bb39381c7379a\"")
  }
}

test "md5 2" {
  if md5("good", bit=32) != "755f85c2723bb39381c7379a604160d8" {
    return Err("md5(\"good\", bit=32) != \"755f85c2723bb39381c7379a604160d8\"")
  }
}

test "md5 3" {
  if md5("你好", bit=16) != "87d23676fa37a4b1" {
    return Err("md5(\"你好\", bit=16) != \"87d23676fa37a4b1\"")
  }
}

test "md5 4" {
  if md5("你好", bit=32) != "c50de6c887d23676fa37a4b174300120" {
    return Err("md5(\"你好\", bit=32) != \"c50de6c887d23676fa37a4b174300120\"")
  }
}
