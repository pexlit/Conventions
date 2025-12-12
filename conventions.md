naming conventions:
# PHP
functions: snake_case
classes: PascalCase
files: snake_case

# C++
functions: camelCase
classes: PascalCase
files: camelCase

make all functions constexpr where possible. don't add overloads for arguments which can be combined into arguments for an existing overload.
setData(x,y) is redundant when we have setData(pos) because we can call setData({x,y})

use as short initializers as possible.
int exampleVal{};
glm::vec3 exampleVector{0,1,2};

# javascript
functions: camelCase
classes: PascalCase
files: snake_case

# any language

## proper function names
describe what it does. don't give any unnecessary information about inner workings or what it's needed for. you never know if it might be used for something else.

## DRY


