# CSpec design

> TODO: use common design of `discovery`, `runner`, `reporter` with dependency injection

## `CSpec.cmake` Command-Line Interface

| Argument | Description |
|-|-|
| `-DCSPEC_ACTION` | One of: `LIST_TEST_FUNCTIONS`, `RUN_FILE`, `RUN_TEST` |
| `-DCSPEC_FILE` | Path to the `.cmake` file representing this test suite |
| `-DCSPEC_TEST` | Name of test function (_for `RUN_TEST` action_) |
| `-D[variety of things]` | Anything like the runner, reporter, discovery thingy, all need to get passed down (?) |

## Test Run Types

> TODO: runners should be extensible. Reporters too :P

`CSpec` can be run in a variety of ways, depending on your personal preference:

1. Tests run immediately at **generation time** (_get results right away!_)
2. Test run at **build time** (_custom target_)
3. Tests run via `CTest`

This can be configured via:
- `CSPEC_RUN_TYPE` or `$ENV{CSPEC_RUN_TYPE}`

Available values are:
- `IMMEDIATE` (_tests run on CMake generation_)
- `BUILD` (_tests run via custom added target_)
- `CTEST` (_tests run via CTest_)

> Multiple values can be selected, e.g. `BUILD;CSPEC`

### Level of detail

- Do you want one build target (_or CTest_) for ALL of your test files?
- Do you want one build target (_or CTest_) \*_per_\* test **file**?
- Do you want one build target (_or CTest) \*_per_\* test **function**?

This can be configured via:
- `CSPEC_DETAIL_LEVEL` or `$ENV{CSPEC_DETAIL_LEVEL}`
- Or for specific runners:
  - ...

Available valaues are:
- ...

### Tests run immediately (_at generation time_)

```cmake
add_cspec_suite(path/to/tests.cmake )
```

### Tests run when target is built (_custom target_)

### Tests run via `CTest`