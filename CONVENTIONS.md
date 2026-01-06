conventions:

# idea
the core idea of our coding style is as follows:

- lower complexity:

- avoid 'hiding problems' by, for example, validation. let our code break if there's a bug. we need to solve the underlying problem, not ignore it.

- keep structure in the code.

- merge if possible. DRY

- make sure code is self-explanatory. if that's not fully possible, explain yourself.

# any language

## explanation

put comments before complex code, if (variable) names do explain themselves but the function is still too complex to understand and cannot easily be separated in more logical functions.

## placement

code should be in relevant files.
in c++, do not place a randomPointOnSphere function in blackhole.cpp.
instead, create a new file like 'math/randomFunctions.cpp'.

files should be in a directory that makes sense.
blackhole.cpp should be inside a folder like 'celestial_body'.
folder names are singular and snake_case.

each struct and enum should have it's own file.

files of more than 1000 lines are PROHIBITED. they probably contain multiple violations of the conventions and do not actually reflect the intention of the author. they make files hard to read and edit.

## validation
don't implement checks if not necessary.
mostly, values being off indicate a deeper issue. normalizing them equals curing symptoms.


only external data needs to be validated. we can safely assume shaders have a certain variable, for example. we don't have to check for this every time when setting the uniforms value. the program should probably crash 
when the first check fails, anyways.
validate:
user defined input, like json
don't validate:
modifiable but not normally user defined input which could not pose a security risk, like shader code
internal variables on which the user has no effect
float f = random0To1() * 5;
bad:
clamp(f, 0, 5);
we can guarantee the variable to be between 0 and 5.

workarounds are not allowed. we need to solve the core problem. when you hit into an issue, please report this instead of creating a 'helper', 'temporary fix' etc.

## proper function names
describe what it does. don't give any unnecessary information about inner workings or what it's needed for. you never know if it might be used for something else.

do not abbreviate names except if they're used a lot and it's obvious what it means.
bad:
for(int i = 0; i < 100; i++){}
good:
for(int cellIndex = 0; cellIndex < 100; cellIndex++){}

## use enums

int state = 0; is bad. use enums!

## DRY
do not repeat the same constant numbers with the same meaning, but define them!

## notation
if something is more understandable when it's a binary or hexadecimal number, use that number system. or define a constant which name explains what it is and use that.
bad:
int mask = 7;
good:
int mask = 0b111;

bad:
number & 7
good:
int lowerBitsMask = 0b111;
number & lowerBitsMask

## keep it as simple as possible
beware for unnecessary complexity. do not make a function like this:

void setFrameRate(int frameRate){
    frameRate = 60;
}

it just adds complexity and increases compile time. we can easily change this into a function when the time comes that something else needs to update when framerate changes.

## clean up after yourself

if you are testing things to find the cause of a bug, make sure to revert changes if they didn't help.

## math
we use OpenGL conventions. for example,
mesh is culled counter clockwise, coordinate system is right handed, etc. 
we always use reverse-z matrices for extra precision.
for our models and in world space, Z = up, y = front and x = right. this does not apply to space or planets.
in camera space, y = up, x = right, -z = forward.

## spatial awareness

make sure your code is understandable by prefixing direction vectors with their coordinate space:
bodyRight, cameraUp
localRotation, worldRotation

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
do not fill in any template parameters when not necessary.

do not write expansive code when the same thing can be done with the same performance in less code:

int sampleInt = static_cast<int>(sampleFloat);
you can just write int sampleInt = (int)sampleFloat;

avoid using global variables. a source file can have global variables, but refrain from using those in other source files. you probably need to pass them in a function as (const) reference.

use destructors and constructors, not init() and cleanup(). prefer keeping object as struct members instead of static objects.

delete everything you allocate (on program exit or before opengl context destruction if necessary). for reference: on windows, _crtdumpmemoryleaks() should return nothing.

to exit an outer loop without needing to set data, just use a label and goto. it's one of the few cases where goto is valid.



set opengl states before each draw call, and do not reset them. this saves code and reduces complexity.

# javascript
functions: camelCase
classes: PascalCase
files: snake_case
