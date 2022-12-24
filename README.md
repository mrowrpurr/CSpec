# CSpec

> Test Framework for CMake

![CSpec](Images/CSpec.png)

# Install

`CSpec` [*will be*] available via `vcpkg` (from `mrowrpurr`'s [`vcpkg` repo](https://github.com/mrowrpurr/vcpkg))

## Get from `vcpkg`

1. Add `cspec` as a dependency to your `vcpkg.json`
1. Add `mrowrpurr`'s `vcpkg` registry to your `vcpkg-configuration.json`

### `vcpkg.json`

<details>
    <summary>View Content</summary>

```json
{
    "$schema": "https://raw.githubusercontent.com/microsoft/vcpkg/master/scripts/vcpkg.schema.json",
    "name": "my-project",
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
      "repository": "https://github.com/mrowrpurr/vcpkg.git",
      "baseline": "< INSERT THE LATEST COMMIT SHA >",
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
add_cspec_suite(specs/MySpecs)
```

### `MySpecs.cmake`

```cmake
set(SomeGlobalVariable)

function(setup)
    # This will be run before each test run.
    # Note tests are run in SEPARATE processes and do not share variables.
    set(SomeGlobalV)
endfunction()

function(test_this_should_pass)
    # because this function starts with "test_"
    # it will be automatically run!
endfunction()

function(test_this_should_fail)
    # anything which will cause the program to fail
    # will cause the test to fail:
    message(SEND_ERROR "This message will show up in test output")
endfunction()
```
