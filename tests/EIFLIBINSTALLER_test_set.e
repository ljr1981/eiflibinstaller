note
	description: "Tests of {EIFLIBINSTALLER}."
	testing: "type/manual"

class
	EIFLIBINSTALLER_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	EIFLIBINSTALLER_tests
			-- `EIFLIBINSTALLER_tests'
		local
			l_output: FW_PROCESS_HELPER
			l_git_cmd,
			l_ff_cmd,
			l_cmd,
			l_result: STRING
			l_file: PLAIN_TEXT_FILE
		do
			create l_output
			l_git_cmd := "%N%"" + l_output.output_of_command ("where git", "./") + " version%"%N"
			l_ff_cmd := "%N%"C:\Program Files\Eiffel Software\EiffelStudio 20.05 Standard\studio\spec\win64\bin\finish_freezing.exe%" -version%N"

			create l_file.make_create_read_write ("vcpkg_cmd.bat")
			l_file.putstring (vcpkg_cmd)
--			l_file.putstring (l_git_cmd)
			l_file.putstring (l_ff_cmd)
			l_file.close

			l_cmd := "vcpkg_cmd.bat"
			l_result := l_output.output_of_command (l_cmd, "./")
			assert_strings_equal ("output", "", l_result)
		end

feature {NONE} -- Implementation

	vcpkg_cmd: STRING = "[
CALL "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsx86_amd64.bat"
CALL "C:\Program Files\Eiffel Software\EiffelStudio 20.05 Standard\studio\config\win64\esvars.bat"
D:\Users\LJR19\Documents\GitHub\vcpkg\vcpkg.exe help topics
CALL "D:\Users\LJR19\Documents\GitHub\vcpkg\bootstrap-vcpkg.bat"
]"

	finish_freezing_result: STRING = "[

]"

end
