struct {
    char* characters;
    int length;
} String;

char* file = open_file("...");
String str = {.characters = file};
char* copy = file;
while (*copy++) str.length++;

enum {
    Identifier;

    Let;
    True;
    False;

    Integer;
    Float;

    // ....
    L_Paren = '(';
    R_Paren = ')';
}
Token;

struct {
    Token type;
    String value;  // The thing we captured during lexing
} Lexeme;

// (let x (add (mod (fn 100.5) 2), 3))
// Char: '('
// Let: 'let'
// Identifier: 'x'
// ... '(' 'add2nums' '(' 'mod' '(' 'fn' '100.5' ')' '2' ')' ',' '3' ')' ')'

Array<Lexeme> lexemes = {0};
Builder capture = {0};

// Lexical scanning
int i = 0;
int line = 1;
int column = 1;
while (i < str.length) {
    char chr = str[i];

    // start an identifier
    if (starts_identifier(chr)) {
        int x = i;
        while (x < str.length) {
            char chr = str[x];
            if (!continues_identifier(chr)) break;
            append(&capture, chr);
            x += 1;
        }

        String str = builder_to_string(&capture);
        switch (str) {
            case "let":
                push(&lexemes, (Lexeme){Let, str});
                break;

            case "true":
                push(&lexemes, (Lexeme){True, str});
                break;

            case "false":
                push(&lexemes, (Lexeme){False, str});
                break;

            default:
                push(&lexemes, (Lexeme){Identifier, str});
                break;
        }

        reset_builder(&capture);

        i = x;
        continue;
    }

    // starts a number
    // what a number actually is
    // ....
    if (starts_number(chr)) {
        int x = i;
        while (x < str.length) {
            char chr = str[x];
            if (!continues_number(chr)) break;
            append(&capture, chr);
            x += 1;
        }

        printf("Number: %s\n", builder_to_string(&capture));
        reset_builder(&capture);

        i = x;
        continue;
    }

    switch (chr) {
        case L_Paren:
        case R_Paren:
            printf("Char: %c\n", chr);
            break;

        default:
            error("Invalid character: '%c'", chr);
            break;
    }
}

// Printing the tree
i = 0;
while (i < lexemes.length) {
    Lexeme lexeme = lexemes[i];
    i += 1;
}