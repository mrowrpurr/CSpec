# CSpec

> Test Framework for CMake

![CSpec](Images/CSpec.png)

- [CSpec](#cspec)
- [What?](#what)
- [Install](#install)
  - [Get from `vcpkg`](#get-from-vcpkg)
    - [`vcpkg.json`](#vcpkgjson)
    - [`vcpkg-configuration.json`](#vcpkg-configurationjson)
  - [Add to `CMakeLists.txt`](#add-to-cmakeliststxt)
- [Write Tests](#write-tests)
    - [`MySpecs.cmake`](#myspecscmake)
    - [Example Output](#example-output)
    - [Assertions](#assertions)

# What?

[`CMake`](https://cmake.org/) scripts can be pretty complex.

I wanted to be able to [test-drive](https://en.wikipedia.org/wiki/Test-driven_development) my CMake scripts, so I wrote this.

It's *less than* [`80 lines of code`](cmake/CSpec.cmake), but provides a lovely test interface.

# Install

`CSpec` is available via `vcpkg` (from `mrowrpurr`'s [`vcpkg` repo](https://github.com/mrowrpurr/vcpkg-repo))

## Get from `vcpkg`

1. Add `cspec` as a dependency to your `vcpkg.json`
1. Add `mrowrpurr`'s `vcpkg` registry to your `vcpkg-configuration.json`

### `vcpkg.json`

<details>
    <summary>View Content</summary>

```json
{
    "$schema": "https://raw.githubusercontent.com/microsoft/vcpkg/master/scripts/vcpkg.schema.json",
    "name": "hello-world",
    "version-string": "0.0.1",
    "dependencies": [
        "cspec"
    ]
}
```

</details>

### `vcpkg-configuration.json`

<details>
    <summary>View Content</summary>

```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/microsoft/vcpkg.git",
    "baseline": "cc288af760054fa489574bd8e22d05aa8fa01e5c"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/mrowrpurr/vcpkg-repo.git",
      "baseline": "fbc7feae4c02684332fe6c9fec8320bef34729b3",
      "packages": [
        "cspec"
      ]
    }
  ]
}
```

</details>

## Add to `CMakeLists.txt`

Once you've added `cspec` as a `vcpkg` dependency, simply install it via `CMake`:

```cmake
find_package(CSpec CONFIG REQUIRED)
```

# Write Tests

Writing tests is easy, just make a `[whatever].cmake` file.

In your `CMakeLists.txt`, specify the file:

```cmake
# You can leave off the .cmake extension
add_cspec_suite(MySpecs)
```

### `MySpecs.cmake`

```cmake
function(setup)
    # This runs before each test function is run.
    # Note: tests are run in SEPARATE processes and do not share variables.
    do_some_setup()
    set(SomeSharedVariable "Shared Value" PARENT_SCOPE)
endfunction()

function(teardown)
    # This runs after each test function is run (even if the test fails).
    do_some_cleanup()
endfunction()

function(test_this_should_pass)
    # Because this function starts with "test_"
    # it will be automatically run!
    
    # Also, setup() runs before this so we have access to shared variables:
    message("I got a value from setup() - ${SomeSharedVariable}")
endfunction()

function(test_this_should_fail)
    # Anything which will cause the program to fail
    # will cause the test to fail:
    message(SEND_ERROR "This message will show up in test output")
endfunction()
```

### Example Output

```
[build]   [FAIL] test_should_fail
[build]       CMake Error at C:/Users/mrowr/AppData/Local/Temp/cspec/ec308d4b3c337173b30c142dfd5ff1e7bf9dbe82/HelloCSpec.cmake:16 (message):
[build]         This should be a failure message!
[build]       Call Stack (most recent call first):
[build]         C:/Code/mrowrpurr/CSpec/CSpec.cmake:52:EVAL:1 (test_should_fail)
[build]         C:/Code/mrowrpurr/CSpec/CSpec.cmake:52 (cmake_language)
[build]         C:/Users/mrowr/AppData/Local/Temp/cspec/ec308d4b3c337173b30c142dfd5ff1e7bf9dbe82/HelloCSpec.cmake:19 (__cpec_test_suite_end)
[build]   [PASS] test_should_pass
```

### Assertions

At this time, there are no custom assertions written.

Simply `message(SEND_ERROR "something")` or `message(FATAL_ERROR "something)` to fail a test.
