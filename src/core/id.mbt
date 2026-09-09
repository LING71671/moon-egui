///|
pub struct Id {
  val : UInt64
} derive(Eq, Debug, Default)

///|
pub fn Id::new(val : UInt64) -> Id {
  { val, }
}

///|
pub fn Id::zero() -> Id {
  { val: 0UL, }
}

///|
pub fn Id::is_valid(self : Id) -> Bool {
  self.val != 0UL
}

///|
pub fn Id::from_string(str : String) -> Id {
  Id::with_seed(14695981039346656037UL, str)
}

///|
pub fn Id::with_seed(seed : UInt64, str : String) -> Id {
  let mut hash = seed
  let prime = 1099511628211UL
  for i = 0; i < str.length(); i = i + 1 {
    let char_code = str[i].to_int().to_uint64()
    hash = (hash ^ char_code) * prime
  }
  { val: hash, }
}

///|
pub fn Id::combine(self : Id, other : Id) -> Id {
  let prime = 1099511628211UL
  { val: (self.val ^ other.val) * prime, }
}

///|
pub struct IdStack {
  stack : Array[UInt64]
} derive(Eq, Debug)

///|
pub fn IdStack::new() -> IdStack {
  { stack: [14695981039346656037UL], }
}

///|
pub fn IdStack::current_seed(self : IdStack) -> UInt64 {
  if self.stack.is_empty() {
    14695981039346656037UL
  } else {
    self.stack[self.stack.length() - 1]
  }
}

///|
pub fn IdStack::push(self : IdStack, str : String) -> Unit {
  let parent = self.current_seed()
  let next_id = Id::with_seed(parent, str).val
  self.stack.push(next_id)
}

///|
pub fn IdStack::pop(self : IdStack) -> Unit {
  if self.stack.length() > 1 {
    let _ = self.stack.pop()
  }
}

///|
pub fn IdStack::derive_id(self : IdStack, str : String) -> Id {
  Id::with_seed(self.current_seed(), str)
}
