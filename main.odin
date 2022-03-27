package main
import "core:fmt"
import "core:strings"

Token :: enum {
	Identifier,
	Let,
	True,
	False,
	Integer,
	Float,
	L_Paren = '(',
	R_Paren = ')',
}

Lexeme :: struct {
	token: Token,
	value: string,
}

starts_identifier :: proc(b: byte) -> bool {
	switch b {
	case 'A' .. 'Z', 'a' .. 'z':
		return true
	}
	return false
}

starts_number :: proc(b: byte) -> bool {
	switch b {
	case '0' .. '9', '.':
		return true
	}
	return false
}

continues_identifier :: proc(b: byte) -> bool {
	switch b {
	case 'A' .. 'Z', 'a' .. 'z', '0' .. '9':
		return true
	}
	return false
}

continues_number :: proc(b: byte) -> bool {
	switch b {
	case '0' .. '9', '.':
		return true
	}
	return false
}

main :: proc() {
	file := "(let x (add2nums (mod (fn 100.7) 2 3)))"
	capture: strings.Builder
	lexemes := [dynamic]Lexeme{}

	i := 0
	for i < len(file) {
		chr := file[i]

		if (starts_identifier(chr)) {
			x := i
			for x < len(file) {
				chr := file[x]

				if !continues_identifier(chr) do break
				strings.write_byte(&capture, chr)
				x += 1
			}

			str := strings.to_string(capture)

			switch str {
			case "let":
				append(&lexemes, Lexeme{.Let, "let"})
			case "true":
				append(&lexemes, Lexeme{.True, "true"})
			case "false":
				append(&lexemes, Lexeme{.False, "false"})
			case:
				append(&lexemes, Lexeme{.Identifier, strings.clone(str)})
			}

			strings.reset_builder(&capture)

			i = x
			continue
		}

		if (starts_number(chr)) {
			x := i
			for x < len(file) {
				chr := file[x]
				if !continues_number(chr) do break
				strings.write_byte(&capture, chr)
				x += 1
			}

			str := strings.to_string(capture)

			if (strings.contains(str, ".")) {
				append(&lexemes, Lexeme{.Float, strings.clone(str)})
			} else {
				append(&lexemes, Lexeme{.Integer, strings.clone(str)})
			}


			strings.reset_builder(&capture)

			i = x
			continue
		}


		switch chr {
		case '(':
			append(&lexemes, Lexeme{.L_Paren, "("})
		case ')':
			append(&lexemes, Lexeme{.R_Paren, ")"})
		case ' ':
		case:
			fmt.println("Invalid character: ", cast(rune)chr)
		}

		i += 1
	}


	for lexeme in lexemes {
		fmt.printf(lexeme.value)
	}
	fmt.println()
}
