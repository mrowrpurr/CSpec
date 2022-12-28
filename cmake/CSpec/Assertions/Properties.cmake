macro(ASSERT_PROPERTY_EQUAL expected property_name)
    block()
        get_property(property_value ${ARGN} PROPERTY "${property_name}")
        if(NOT "${property_value}" STREQUAL "${expected}")
            separate_arguments(args NATIVE_COMMAND "${ARGN}")
            string(REGEX REPLACE ";" " " args "${args}")
            expect_fail("Expected property '${property_name}' of ${args} to equal '${expected}' but was '${property_value}'")
        endif()
    endblock()
endmacro()

macro(__expect_be_property positive expected property_name)
    block()
        list(APPEND args ${ARGN})
        list(GET args 0 __expect_be_property_first)
        if("${__expect_be_property_first}" STREQUAL "of")
            list(POP_FRONT args)
        endif()
        if(${positive})
            ASSERT_PROPERTY_EQUAL("${expected}" "${property_name}" ${args})
        else()
            message(FATAL_ERROR "be_property does not currently support 'not'")
        endif()
    endblock()
endmacro()
