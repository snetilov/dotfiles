# NVIMTUTOR · Java edition

```text
 ================================================================
 =    W e l c o m e   t o   t h e   J a v a   N V I M T U T O R  =
 =        built from YOUR config  ·  Neovim 0.12  ·  ~2 hours     =
 ================================================================
```

This is a hands-on course in the spirit of `vimtutor`, generated from the
config in `~/.config/nvim`. Every key below is either mapped in your config,
provided by one of your plugins, or a Neovim built-in your config relies on
(several custom LSP/quickfix maps were removed in favour of these built-ins).

## How to use this tutor

- Read it **inside Neovim**: `nvim ~/.config/nvim/TUTOR.md`.
  `render-markdown` renders it and spell-check is on for markdown, so ignore
  red squiggles under code.
- Lines that start with `--->` are practice lines. **Edit them.** In Lesson 0.2
  you get a private copy of this file, so you never touch your dotfiles.
- Notation:
  - `<Space>` is your **leader**. `<Space>ff` = Space, then `f`, then `f`.
  - `<C-x>` = Ctrl+x, `<A-x>` = Alt+x, `<S-Tab>` = Shift+Tab, `<CR>` = Enter.
  - Keys are typed in **Normal mode** unless a lesson says otherwise.
- Many leader keys share a prefix. If you pause for more than 1 s
  (`timeoutlen`) Neovim stops waiting; just type the sequence again.

| Chapter | Topic                                  |
| ------- | -------------------------------------- |
| 0       | Setup: training wheels and playground  |
| 1       | Core editing refresher                 |
| 2       | Files, windows, tabs, pickers          |
| 3       | Writing Java fast                      |
| 4       | Understanding code with jdtls          |
| 5       | Refactoring                            |
| 6       | Debugging                              |
| 7       | Running and debugging tests            |
| 8       | Git                                    |
| 9       | Sessions and odds and ends             |
| A, B    | Cheat sheet, gotchas                   |

---

## Chapter 0: Setup

### Lesson 0.1: Training wheels that are already on

Your config loads three learning plugins. The `_` prefix in
`lua/plugins/_*.lua` only marks them as temporary; lazy.nvim still loads them.

- **hardtime.nvim** blocks `h` `j` `k` `l` (and `+`, `gj`, `gk`, `<C-n>`,
  `<C-p>`) after 3 presses within 1 s, then suggests a better motion. Arrow
  keys are disabled in Normal and Insert mode. Use counts (`5j`), `}`, `/`
  search and `<C-d>`.
  `:Hardtime toggle` turns it off. `:Hardtime report` lists your worst habits.
- **precognition.nvim** shows hint letters around the cursor (`w` `b` `e`
  `^` `$` `%`, plus `gg` `G` `{` `}` in the gutter) that mark where each
  motion would land. `:Precognition toggle` and `:Precognition peek`.
- **vim-be-good** is a motion-drill game. It has no load trigger, so run
  `:Lazy load vim-be-good` and then `:VimBeGood`.

The mouse is disabled (`mouse = ""`), so this course is keyboard-only.

### Lesson 0.2: Create the Java playground

**You'll run a shell script straight from this buffer.**

Chapters 3 to 8 need a real Maven project for jdtls, the debugger and the test
runner. The script creates `~/nvim-tutor`: a small Maven project with git
history, plus a copy of this tutor that you can edit freely. Running it again
resets the files.

  1. Type `/^T=` and press `<CR>` to jump to the first line of the script.
  2. Press `V` to start a linewise Visual selection.
  3. Type `/END OF SETUP` and press `<CR>`. The selection grows to that line.
  4. Type `:`. Neovim pre-fills `:'<,'>`. Complete it to `:'<,'>w !bash`
     and press `<CR>`. Keep the space between `w` and `!`: `w !cmd` pipes the
     lines into a command, while `w!` would force-write a file.
  5. You should see `Playground ready in .../nvim-tutor`. Press `<CR>`.

```bash
T=~/nvim-tutor && mkdir -p $T/src/main/java/dev/tutor/shapes $T/src/test/java/dev/tutor && cd $T
cat > pom.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>dev.tutor</groupId>
  <artifactId>nvim-tutor</artifactId>
  <version>1.0-SNAPSHOT</version>
  <properties>
    <maven.compiler.release>21</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>
  <dependencies>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>5.10.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>3.5.2</version>
      </plugin>
    </plugins>
  </build>
</project>
EOF
cat > src/main/java/dev/tutor/shapes/Shape.java <<'EOF'
package dev.tutor.shapes;

public interface Shape {

    double area();

    String name();
}
EOF
cat > src/main/java/dev/tutor/shapes/Circle.java <<'EOF'
package dev.tutor.shapes;

public record Circle(double radius) implements Shape {

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }

    @Override
    public String name() {
        return "circle";
    }
}
EOF
cat > src/main/java/dev/tutor/shapes/Rectangle.java <<'EOF'
package dev.tutor.shapes;

public class Rectangle implements Shape {

    private final double width;
    private final double height;

    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }

    @Override
    public double area() {
        return width * heigth; // TUTOR: deliberate typo, fixed in Lesson 4.3
    }

    @Override
    public String name() {
        return "rectangle";
    }
}
EOF
cat > src/main/java/dev/tutor/OrderService.java <<'EOF'
package dev.tutor;

import java.util.List;

import dev.tutor.shapes.Shape;

public class OrderService {

    private double taxRate = 0.2;

    public double price(int quantity) {
        double base = quantity * 9.99;
        if (quantity > 10) {
            base = base * 0.9;
        }
        return base + base * taxRate;
    }

    public double totalArea(List<Shape> shapes) {
        double sum = 0;
        for (Shape shape : shapes) {
            sum += shape.area();
        }
        return sum;
    }
}
EOF
cat > src/main/java/dev/tutor/App.java <<'EOF'
package dev.tutor;

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import dev.tutor.shapes.Circle;
import dev.tutor.shapes.Rectangle;
import dev.tutor.shapes.Shape;

public class App {

    public static void main(String[] args) throws IOException {
        OrderService service = new OrderService();
        List<Shape> shapes = List.of(new Circle(1.5), new Rectangle(2, 3), new Circle(0.5));
        for (int i = 0; i < 10; i++) {
            double total = service.totalArea(shapes) * i;
            System.out.println("iteration " + i + " total=" + total);
        }
        startServer(service);
    }

    static void startServer(OrderService service) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/price", exchange -> {
            String query = exchange.getRequestURI().getQuery();
            int qty = Integer.parseInt(query.split("=")[1]);
            double price = service.price(qty);
            byte[] body = ("{\"qty\":" + qty + ",\"price\":" + price + "}").getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().add("Content-Type", "application/json");
            exchange.sendResponseHeaders(200, body.length);
            try (OutputStream out = exchange.getResponseBody()) {
                out.write(body);
            }
        });
        server.start();
        System.out.println("Listening on http://localhost:8080/price?qty=3");
    }
}
EOF
cat > src/test/java/dev/tutor/OrderServiceTest.java <<'EOF'
package dev.tutor;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class OrderServiceTest {

    private final OrderService service = new OrderService();

    @Test
    void priceOfOneItemIncludesTax() {
        assertEquals(11.988, service.price(1), 0.0001);
    }

    @Test
    void bulkDiscountApplies() {
        // TUTOR: wrong on purpose, fixed in Lesson 7.2
        assertEquals(100.0, service.price(20), 0.0001);
    }
}
EOF
cat > requests.http <<'EOF'
### Price for three items
GET http://localhost:8080/price?qty=3

### Bulk price (discount kicks in above 10)
GET http://localhost:8080/price?qty=20
EOF
cp ~/.config/nvim/TUTOR.md "$T/TUTOR.md"
printf 'target/\nbin/\n.classpath\n.project\n.settings/\n.factorypath\nTUTOR.md\nSession.vim\n' > .gitignore
git init -q
git config user.name >/dev/null || git config user.name tutor
git config user.email >/dev/null || git config user.email tutor@localhost
git add -A && git commit -qm "Playground initial state"
echo "Playground ready in $T"
# END OF SETUP SCRIPT
```

Requirements: JDK 21+ (your jdtls runs on JDK 25), `git`, `curl` (for
kulala), and Maven only for Lesson 6.9. jdtls downloads JUnit on first import.

### Lesson 0.3: Move into the playground

  1. Type `:cd ~/nvim-tutor` and press `<CR>`. Pickers and grep now search
     the playground.
  2. Type `:e TUTOR.md` and press `<CR>`. **From now on you are in your
     private copy**, so edit anything.
  3. Press `<Space>sv` to split. Read the tutor on the left, open code on the
     right, and switch between them with `<C-h>` and `<C-l>`.

Next time, start with `cd ~/nvim-tutor && nvim TUTOR.md`.

```text
 CHAPTER 0 SUMMARY
  - hardtime: use counts and real motions instead of repeating hjkl. :Hardtime toggle
  - precognition: hints show where motions land. :Precognition toggle
  - :'<,'>w !bash pipes the selected lines into a shell
  - :cd {dir} changes the working directory for pickers and grep
```

---

## Chapter 1: Core editing refresher

The essentials you will use all day, tuned to your settings.

### Lesson 1.1: Moving with intent

| Keys                  | Moves to                                         |
| --------------------- | ------------------------------------------------ |
| `w` / `b` / `e`       | next word / previous word / end of word          |
| `W` / `B` / `E`       | the same, using whitespace-separated WORDs       |
| `0` / `^` / `$`       | column 0 / first non-blank / end of line         |
| `f{c}` / `t{c}`       | onto / just before the next `{c}` on the line    |
| `F{c}` / `T{c}`       | the same, backwards                              |
| `;` / `,`             | repeat the last `f`/`t` forward / backward       |
| `%`                   | matching `(` `)`, `{` `}` or `[` `]`             |
| `gg` / `G` / `42G`    | first line / last line / line 42                 |
| `{` / `}`             | previous / next blank line (paragraph)           |
| `<C-d>` / `<C-u>`     | half a page down / up                            |
| `zz`                  | center the cursor line on screen                 |

Relative line numbers are on: the gutter shows how far each line is, so `7j`
lands exactly. Insert mode switches to absolute numbers.

  1. Put the cursor on the line below, then press `0`, `w` `w` `w`, `e`, `$`, `^`.
  2. Press `f"` to reach the opening quote, then `;` for the next quote and `,`
     to go back.
  3. Press `t:` and then `F/`.

```text
---> public static final String DB_URL = "jdbc:postgresql://localhost:5432/orders";
```

**Gotcha:** your config adds `-` to `iskeyword`. `w`, `*` and `ciw` treat
`count-1` as a single word. Try `ciw` on `count-1` below and type `next`.

```text
---> int next = count-1;
```

### Lesson 1.2: Operators and text objects

**Grammar: operator + motion or text object, e.g. `d` `w`, `c` `i(`, `y` `a{`.**

| Operator | Does          |   | Text object         | Selects                       |
| -------- | ------------- | - | ------------------- | ----------------------------- |
| `d`      | delete        |   | `iw` / `aw`         | word / word plus its space    |
| `c`      | change        |   | `i"` / `a"`         | inside / including quotes     |
| `y`      | yank (copy)   |   | `i(` / `a(`         | inside / including parens     |
| `>` `<`  | indent        |   | `i{` / `a{`         | inside / including braces     |
| `gc`     | comment (3.3) |   | `ip` / `it`         | paragraph / XML-HTML tag body |

Shortcuts: `dd`, `cc` and `yy` act on a line. `D` and `C` act to the end of
the line, and `x` deletes one character. `.` repeats the last change. `u`
undoes and `<C-r>` redoes. Undo history survives restarts (`undofile`).

  1. On the first line below, put the cursor anywhere inside the `if (...)`
     condition, type `ci(`, then `order.isLarge()`, then `<Esc>`.
  2. On the second line, put the cursor inside the string and type `di"`.
  3. Put the cursor on `getName` and type `cw`, then `getEmail` and `<Esc>`.
  4. Type `u` three times, then `<C-r>` once.

```text
---> if (order.getStatus() == Status.NEW && order.getTotal().compareTo(LIMIT) > 0) {
---> log.info("Created order {} for customer {}", order.getId(), customer.getName());
```

### Lesson 1.3: Search and replace

| Keys                    | Does                                               |
| ----------------------- | -------------------------------------------------- |
| `/text` / `?text`       | search forward / backward                          |
| `n` / `N`               | next / previous match                              |
| `*` / `#`               | search the word under the cursor forward / back    |
| `:noh`                  | clear the highlight (`<C-l>` is taken by tmux nav) |
| `:s/old/new/g`          | replace on the current line                        |
| `:%s/old/new/gc`        | replace in the whole file, confirming each match   |
| `:'<,'>s/old/new/g`     | replace inside the Visual selection                |

Search uses `ignorecase` and `smartcase`: all-lowercase patterns ignore case,
and any capital letter makes the search case-sensitive.

  1. Search `/customerid`. All four variants below match.
  2. Search `/customerId`. Only the exact spelling matches.
  3. Type `:s/customer/client/g` on the line, then `u`.

```text
---> customerId customerID CustomerId customerid
```

### Lesson 1.4: Registers, clipboard, undo

- `clipboard=unnamedplus`: every yank **and every delete** goes to the system
  clipboard. Yanked text flashes briefly.
- `"0p` pastes your last *yank*, even after deletes have overwritten the
  clipboard.
- `"_d{motion}` deletes into the black hole, leaving the clipboard alone.
- In Insert mode, `<C-r>"` pastes the unnamed register and `<C-r>0` pastes
  the last yank.

  1. Type `yiw` on `alpha`. Move to `beta` and type `diw`. Now `p` pastes
     `beta`, but `"0p` pastes `alpha`.

```text
---> alpha beta gamma
```

### Lesson 1.5: Visual block and macros

  1. Put the cursor on the `S` of the first `String` below. Press `<C-v>`,
     then `2j`, then `I`. Type `final ` and press `<Esc>`. All three lines change.
  2. Macro: on the first line press `qa`, then `A`, type ` // TODO`, press
     `<Esc>`, `j`, `q`. Then `@a` replays the macro and `@@` repeats it.
     `3@a` runs it three times.

```text
---> String first = "a";
---> String second = "b";
---> String third = "c";
```

### Lesson 1.6: Bracket pairs (Neovim built-ins)

| Keys                  | Does                                        |
| --------------------- | ------------------------------------------- |
| `]<Space>` / `[<Space>` | add an empty line below / above (counts work) |
| `]b` / `[b`           | next / previous buffer                      |
| `]q` / `[q`           | next / previous quickfix item (Lesson 4.5)  |
| `]l` / `[l`           | next / previous location-list item          |
| `]d` / `[d`           | next / previous diagnostic (Lesson 4.3)     |
| `]c` / `[c`           | next / previous diff hunk (Chapter 8)       |

```text
 CHAPTER 1 SUMMARY
  - operator + motion/text object: ciw  di"  ya{  >ip ; repeat with .
  - f t ; ,  %  {  }  <C-d> <C-u>  and counts: 7j
  - / ? n N * # ; :noh ; :%s/a/b/gc ; smartcase
  - deletes also hit the clipboard; "0p = last yank, "_d = delete without copying
  - <C-v> + I for column edits ; qa ... q, @a, @@ for macros
```

---

## Chapter 2: Files, windows, tabs, pickers

### Lesson 2.1: Save and quit

| Keys          | Does                                                   |
| ------------- | ------------------------------------------------------ |
| `<Space>ww`   | `:w` save                                              |
| `<Space>wq`   | `:wq` save and quit                                    |
| `<Space>qq`   | `:q!` quit the window and **discard changes**          |
| `:wa` / `:qa` | save all / quit all                                    |

### Lesson 2.2: Splits (plus tmux)

| Keys                        | Does                                             |
| --------------------------- | ------------------------------------------------ |
| `<Space>sv` / `<Space>ss`   | split vertically / horizontally                  |
| `<Space>sx`                 | close the current split                          |
| `<Space>se`                 | make all splits equal                            |
| `<Space>sh` / `<Space>sl`   | narrower / wider by 5 columns                    |
| `<Space>sj` / `<Space>sk`   | shorter / taller                                 |
| `<Space>sm`                 | zoom the split to full screen, again to restore  |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | move left/down/up/right, **including tmux panes** |
| `<C-\>`                     | go to the previous split or pane                 |

New splits open to the right and below (`splitright`, `splitbelow`).

  1. `<Space>ss`, then `<C-j>` and `<C-k>` to move between the halves.
  2. `<Space>sm` twice (zoom in and out), then `<Space>sk` and `<Space>se`.
  3. `<Space>sx` to close the extra split.

### Lesson 2.3: Tabs

| Keys                      | Does                                  |
| ------------------------- | ------------------------------------- |
| `<Space>to` / `<Space>tx` | open a new tab / close the tab        |
| `<Space>tn` / `<Space>tp` | next / previous tab (`gt` / `gT` too) |

Diffview (Chapter 8) opens in its own tab, so these keys switch to and from it.

### Lesson 2.4: The file explorer (mini.files)

| Keys          | Does                                                  |
| ------------- | ----------------------------------------------------- |
| `<Space>ee`   | open the explorer at the cwd (`<Space>er` does the same) |
| `<Space>ef`   | open the explorer with the **current file revealed**  |

Inside the explorer, each directory is a column:

| Keys          | Does                                                     |
| ------------- | -------------------------------------------------------- |
| `j` / `k`     | move                                                     |
| `l` / `h`     | enter a directory or open a file / go to the parent      |
| `L` / `H`     | like `l` / `h`, but `L` closes the explorer after opening a file and `H` trims the columns on the right |
| `=`           | **apply** the pending file-system edits                  |
| `q`           | close                                                    |
| `g?`          | help                                                     |
| `<BS>` / `@`  | reset / reveal the cwd                                   |
| `m{c}` / `'{c}` | set / jump to a bookmark                               |
| `<Space>ft`   | grep inside the directory under the cursor               |

**You manage files by editing text, then pressing `=`:**

- Create: `o`, type `Notes.md` (a trailing `/` makes a directory), `<Esc>`, `=`.
- Rename: change the name, for example with `ciw`. Avoid `cc`: it also
  removes the hidden entry id and turns the rename into delete plus create.
- Delete: `dd`, then `=`.
- Move or copy: `dd` or `yy`, go to another directory, `p`, then `=`.

Your config also shows git status next to entries: `•` modified, `?`
untracked, `+` added, `!` ignored.

  1. `<Space>ee`, then `l` into `src`, `main`, `java`, `dev`, `tutor`.
  2. `o`, type `scratch.txt`, `<Esc>`, `=`, then confirm.
  3. Rename it: cursor on `scratch`, `ciw`, type `notes`, `<Esc>`, `=`.
  4. Delete it: `dd`, `=`, confirm. Then `q`.
  5. `<Space>ee`, put the cursor on the `src` directory and press `<Space>ft`.
     Type `class` to grep inside it only.

### Lesson 2.5: Pickers (snacks.picker)

| Keys          | Opens                                                   |
| ------------- | ------------------------------------------------------- |
| `<Space>f`    | **smart** picker: buffers, recent files and project files. Type `<Space>f` and **wait about 1 s**, because it's a prefix of the keys below |
| `<Space>ff`   | files under the **current file's directory** (not the project root!) |
| `<Space>fg`   | live grep in the cwd                                    |
| `<Space>fb`   | open buffers                                            |
| `<Space>fs`   | lines of the current buffer                             |
| `<Space>fh`   | help tags                                               |
| `<Space>fo` / `<Space>fm` / `<Space>fi` | LSP symbols / methods / incoming calls (Chapter 4) |
| `<Space>de`   | error diagnostics (Lesson 4.3)                          |

Inside any picker:

| Keys                        | Does                                           |
| --------------------------- | ---------------------------------------------- |
| type                        | fuzzy filter                                   |
| `<C-j>` / `<C-k>`           | move down / up (`<C-n>` / `<C-p>` too)         |
| `<CR>`                      | open                                           |
| `<C-v>` / `<C-s>` / `<C-t>` | open in a vsplit / split / tab                 |
| `<Tab>` / `<S-Tab>`         | multi-select                                   |
| `<C-q>`                     | send the selection (or everything) to quickfix |
| `<C-f>` / `<C-b>`           | scroll the preview                             |
| `<A-p>`                     | toggle the preview                             |
| `<A-h>` / `<A-i>`           | toggle hidden / ignored files                  |
| `<C-Up>` / `<C-Down>`       | search history                                 |
| `<Esc>`                     | leave the prompt for Normal mode (`?` shows help); `<Esc>` or `q` again closes |
| `<C-c>`                     | close immediately                              |

  1. `<Space>f`, wait, type `ordserv`, `<CR>`. This opens `OrderService.java`.
  2. `<Space>fg`, type `price`, move with `<C-j>`, open one with `<C-v>`.
  3. `<Space>fb`, then `<C-c>`.
  4. `<Space>fs`, type `return`, `<CR>`.

### Lesson 2.6: Jumping back and forth

| Keys                 | Does                                                 |
| -------------------- | ---------------------------------------------------- |
| `<C-o>` / `<C-i>`    | back / forward in the jump list (works across files) |
| `<C-^>`              | switch to the alternate (previous) file              |
| `ma` / `` `a ``      | set / jump to mark `a` in this file                  |
| `mA` / `` `A ``      | uppercase marks work **across files**                |
| `gf`                 | open the file path under the cursor                  |
| `gx`                 | open the URL under the cursor in the browser         |

```text
 CHAPTER 2 SUMMARY
  - <Space>ww / wq / qq(discard!) ; :wa :qa
  - <Space>s{v,s,x,e,h,l,j,k,m} splits ; <C-h/j/k/l> also moves across tmux panes
  - <Space>t{o,x,n,p} tabs
  - <Space>ee / ef explorer: edit the text, then = applies it ; <Space>ft grep in dir
  - <Space>f(wait) smart ; ff files near the current file ; fg grep ; fb buffers ; fs lines
  - in pickers: <C-j>/<C-k>, <C-v>/<C-s>/<C-t>, <Tab> select, <C-q> quickfix
  - <C-o>/<C-i> jump list, <C-^> alternate file
```

---

## Chapter 3: Writing Java fast

Open `src/main/java/dev/tutor/App.java` in the right split (`<Space>f`, then
`App`). Give jdtls time on the first open: the status line shows its progress.

### Lesson 3.1: Completion and snippets

Your config uses Neovim 0.12's **built-in** completion, not nvim-cmp. It pops
up automatically as you type, with candidates from the LSP and the current
buffer.

| Keys (Insert mode)       | Does                                              |
| ------------------------ | ------------------------------------------------- |
| `<C-j>` / `<Tab>`        | next item                                         |
| `<C-k>` / `<S-Tab>`      | previous item                                     |
| `<CR>`                   | accept (the first item is preselected)           |
| `<C-e>`                  | dismiss the menu                                  |
| `<C-Space>`              | ask the LSP for completions now                   |
| `<Tab>` / `<S-Tab>`      | with no menu open: jump to the next / previous snippet placeholder |

**Gotcha:** while the menu is open, `<CR>` accepts. For a plain newline,
press `<C-e>` first.

  1. In `main`, put the cursor on the `startServer(service);` line and press `O`.
  2. Type `service.pr` and pick `price(int quantity)` with `<C-j>` and `<CR>`.
  3. If a placeholder is selected, type `5` over it and `<Tab>` out. Finish
     with `;` and `<Esc>`.
  4. Type `u` until the line is gone. Completing a class name such as
     `ArrayL` also adds its `import`.

### Lesson 3.2: Signature help and auto-pairs

- `<C-s>` in Insert mode, or `<Space>gs` in Normal mode, shows the signature
  of the call you're in.
- nvim-autopairs: `(` inserts `()` and `"` inserts `""`. `<CR>` between
  `{}` opens an indented block.

  1. Open `OrderService.java`. Put the cursor on the closing `}` of
     `totalArea`, press `o` and type:
     `public double discount(int quantity) {` and then `<CR>`. The closing brace
     appears by itself.
  2. Type `return quantity > 10 ? 0.1 : 0;` and press `<Esc>`. You'll delete
     this method in Lesson 3.5.

### Lesson 3.3: Comments (mini.comment)

| Keys        | Does                                                    |
| ----------- | ------------------------------------------------------- |
| `gcc`       | toggle the comment on the line                          |
| `gc{motion}`| toggle comments on a motion: `gcip`, `gc3j`, `gcaf` (whole method!) |
| `gc` (Visual) | toggle comments on the selection                      |
| `dgc` / `gcgc` | delete / uncomment the whole comment block under the cursor |

  1. In `App.java`, on the `for` line: `gcc`, then `gcc` again.
  2. Inside `main`: `gcaf` comments the whole method. Then `u`.

### Lesson 3.4: Surround (mini.surround)

`s` is now a **prefix**, so the built-in `s` (substitute a character) is gone.
Use `cl` instead.

| Keys                | Does                                  | Example             |
| ------------------- | ------------------------------------- | ------------------- |
| `sa{motion}{char}`  | add a surrounding                     | `saiw"`             |
| `sd{char}`          | delete a surrounding                  | `sd"`               |
| `sr{old}{new}`      | replace a surrounding                 | `sr'"`              |
| `sf{char}` / `sF{char}` | find the next / previous surrounding |                    |
| `sh{char}`          | highlight a surrounding               |                     |
| `sa{char}` (Visual) | surround the selection                |                     |

Characters: `)` `]` `}` `>` add pairs **without** inner spaces, while `(` `[`
`{` `<` add them **with** spaces. `"` `'` and `` ` `` are quotes. `f` is a
function call (you'll be prompted for the name) and `t` is a tag. Add `n` or `l`
to act on the next or last match: `sdn"`.

  1. On `customer` below: `saiw"`.
  2. Cursor on `value`: `sdf` removes `Objects.requireNonNull(...)`. Then
     `saiwf`, type `Optional.ofNullable` and press `<CR>`.
  3. Inside `'alice'`: `sr'"`. Move into `'bob'` and press `.` to repeat.

```text
---> String name = customer;
---> var v = Objects.requireNonNull(value);
---> List<String> names = List.of('alice', 'bob');
```

### Lesson 3.5: Code-aware text objects (treesitter)

| Object       | Selects                                        |
| ------------ | ---------------------------------------------- |
| `af` / `if`  | a method (whole) / its body                    |
| `ac` / `ic`  | a class (whole) / its body                     |
| `aa` / `ia`  | a parameter or argument, with / without the comma |

They work with any operator (`daf`, `yaf`, `cia`, `daa`, `gcaf`, `>if`). If
the cursor isn't inside a matching node, they jump ahead to the next one on
the line (`lookahead`).

Neovim 0.12 also has **incremental selection** in Visual mode: `an` grows the
selection to the parent node and `in` shrinks it to a child. `]n` / `[n` go
to the next / previous sibling node.

  1. In `OrderService.java`, inside `price`: `vif` selects the body. Press `<Esc>`.
  2. Inside the `discount` method from Lesson 3.2: `daf` deletes it. Then `<Space>ww`.
  3. In `App.java`, on the `List.of(...)` line, put the cursor on the `new`
     before `Rectangle` and type `daa`. Then `u`.
  4. Cursor on `1.5`: `cia`, type `2.5`, `<Esc>`, then `u`.
  5. Cursor on `Circle`: `v`, then `an` `an` `an`, then `in`. Press `<Esc>`.

### Lesson 3.6: Format and fold

- `<Space>gf` formats the file with jdtls. In Visual mode it formats the selection.
- Folds come from treesitter and start open (`foldlevel=20`).

| Keys          | Does                                        |
| ------------- | ------------------------------------------- |
| `za`          | toggle the fold under the cursor            |
| `zc` / `zo`   | close / open the fold                       |
| `zM` / `zR`   | close / open all folds                      |
| `zm` / `zr`   | close / open one more level                 |

  1. In `OrderService.java`, mess up some indentation with `>>` on a few lines,
     then `<Space>gf`.
  2. `zM` folds everything, and `zr` gives a method outline. `zR` opens all
     again.

```text
 CHAPTER 3 SUMMARY
  - completion: <C-j>/<C-k> or <Tab>/<S-Tab>, <CR> accept, <C-e> dismiss, <C-Space> force
  - <C-s> (insert) or <Space>gs signature help ; autopairs for () "" {}<CR>
  - gcc / gc{motion} / gcaf comments
  - sa / sd / sr surround: saiw"  sd)  sr'"  saiwf
  - af if ac ic aa ia treesitter objects ; Visual an / in to grow and shrink
  - <Space>gf format ; za zM zR zr folds
```

---

## Chapter 4: Understanding code with jdtls

### Lesson 4.1: Is jdtls ready?

- jdtls starts when you open a `.java` file. The status line shows its
  progress, and the first import of a project takes a while.
- Workspace data is kept in `~/jdtls-workspace/<project>`.
- `:checkhealth vim.lsp` shows the LSP status. `:JdtShowLogs` opens the logs.
- `:JdtRestart` restarts jdtls. `:JdtWipeDataAndRestart` fixes a confused
  workspace.
- `<Space>gu` (or `:JdtUpdateConfig`) re-imports after you edit `pom.xml` or
  `build.gradle`.
- These keys exist **only in Java buffers**: `<Space>go`, `<Space>gu`,
  `<Space>tc`, `<Space>tm`.

### Lesson 4.2: Hover and go-to

| Keys            | Does                                                    |
| --------------- | ------------------------------------------------------- |
| `K`             | hover documentation. Press `K` again to enter the float; `q` closes it |
| `<C-]>`         | **go to definition** (the LSP backs Vim's tag jumps)    |
| `<C-t>`         | come back from the definition (`<C-o>` also works)      |
| `<C-w>]`        | open the definition in a split                          |
| `<Space>gD`     | go to the declaration                                   |
| `grt`           | go to the type definition                               |
| `gri`           | go to implementations                                   |

  1. In `App.java`: `K` on `HttpServer`, then `K` again and `q`.
  2. `<C-]>` on `OrderService` opens it. Then `<C-t>`.
  3. `<C-]>` on `List` opens JDK code (sources or decompiled). Then `<C-t>`.
  4. `grt` on the variable `service` jumps to its class. Then `<C-o>`.
  5. In `OrderService.java`, `gri` on `area` in `shape.area()` lists Circle and
     Rectangle. Pick one.

### Lesson 4.3: Diagnostics

| Keys          | Does                                                          |
| ------------- | ------------------------------------------------------------- |
| `]d` / `[d`   | next / previous diagnostic. Your config **opens the float automatically** |
| `]D` / `[D`   | last / first diagnostic in the buffer                         |
| `<C-w>d`      | show the diagnostic under the cursor                          |
| `<Space>de`   | picker with every ERROR diagnostic                            |
| `gra`         | code actions and quick fixes for the diagnostic               |

  1. `<Space>de` should list the error in `Rectangle.java`. Press `<CR>`. If
     the list is empty, open `Rectangle.java` with `<Space>f` and press `]d`.
  2. On `heigth`, press `gra`. The menu is a picker, so type `change` and
     choose *Change to 'height'*.
  3. Delete the trailing comment: `f;` then `lD`. Save with `<Space>ww`.
  4. In `App.java`, `]d` lands on the warning about the unused `ArrayList` import.

### Lesson 4.4: References, calls, symbols

| Keys          | Does                                                   |
| ------------- | ------------------------------------------------------ |
| `grr`         | all references, shown in the quickfix list             |
| `<Space>fi`   | incoming calls: who calls this method?                 |
| `gO`          | outline of the file in the location list (`:lclose` closes it) |
| `<Space>fo`   | LSP symbols picker                                     |
| `<Space>fm`   | methods and functions picker (treesitter)              |

  1. In `OrderService.java`, on `price`: `grr` lists the usages in `App.java`
     and `OrderServiceTest.java`.
  2. `<Space>fi` on `price`, then `<C-c>`.
  3. `gO`, then `:lclose`. `<Space>fo`, type `total`, `<CR>`.

### Lesson 4.5: The quickfix workflow

| Keys                      | Does                                          |
| ------------------------- | --------------------------------------------- |
| `<Space>qo` / `<Space>qc` | open / close the quickfix window              |
| `]q` / `[q`               | next / previous item (works while it's closed) |
| `[Q` / `]Q`               | first / last item                             |
| `<CR>` in the list        | jump to the item                              |
| `:colder` / `:cnewer`     | previous / next quickfix list                 |

Quickfix lists come from `grr`, `gri`, `<C-q>` in a picker, and failed tests
(Chapter 7).

```text
 CHAPTER 4 SUMMARY
  - K hover ; <C-]> definition, <C-t> back ; <Space>gD declaration ; grt type ; gri impl
  - ]d [d diagnostics with an auto float ; <C-w>d ; <Space>de errors ; gra quick fix
  - grr references, <Space>fi callers, gO / <Space>fo / <Space>fm symbols
  - <Space>qo / <Space>qc, ]q [q quickfix
  - :JdtRestart, :JdtWipeDataAndRestart, <Space>gu after build-file changes
```

---

## Chapter 5: Refactoring

### Lesson 5.1: Rename

`grn` renames the symbol under the cursor across the project. Renames can
leave changed files unsaved, so follow with **`:wa`**.

  1. In `OrderService.java`, on `taxRate`: `grn`, type `vatRate`, `<CR>`, then `:wa`.
  2. On `totalArea`: `grn`, type `sumOfAreas`, `<CR>`, `:wa`. Check that
     `App.java` was updated.

### Lesson 5.2: Code actions, imports, generators

`gra` works in Normal and Visual mode. The menu is a snacks picker, so type to
filter.

  1. In `App.java`: `<Space>go` (organize imports) removes the unused import.
  2. In `OrderService.java`, on the `vatRate` field: `gra` and choose
     *Generate Getter and Setter for 'vatRate'*.
  3. On the class name `OrderService`: `gra` and look at *Generate toString()*,
     *Generate hashCode() and equals()*, *Generate Constructors* and
     *Override/Implement Methods*. Your `toString` template produces
     `ClassName{field=value, ...}`. Undo with `u` if you try one.

### Lesson 5.3: Extract constant and extract method

  1. In `price`, go to the `double base` line and type `0f9` to land on the
     `9` of `9.99`. Select it with `vt;`, press `gra` and choose *Extract to
     constant*. Then `grn` the new constant to `UNIT_PRICE`.
  2. Put the cursor on the `if (quantity > 10) {` line. `$` moves to the `{`,
     and `V%` selects the whole `if` block. Press `gra`, choose *Extract to
     method*, then `grn` the result to `applyBulkDiscount`. Finish with `:wa`.

### Lesson 5.4: Project-wide search and replace (quickfix plus `:cdo`)

  1. `<Space>fg`, type `return "`. You should see the two `name()` methods.
  2. `<C-q>` sends the matches to the quickfix list.
  3. Run `:cdo s/return "\(\w\)/return "\u\1/ | update` to capitalize the
     shape names in every file and save them.
  4. `]q` and `[q` to review.

`:cdo` runs once per quickfix item. `:cfdo` runs once per file, for example
`:cfdo %s/old/new/ge | update`.

### Lesson 5.5: More jdtls commands

| Command                     | Does                                               |
| --------------------------- | -------------------------------------------------- |
| `:JdtCompile full`          | full rebuild (`incremental` also works)            |
| `:JdtUpdateConfig`          | re-import the build files (same as `<Space>gu`)    |
| `:JdtBytecode`              | `javap` output for the current class               |
| `:JdtJshell`                | jshell with the project classpath                  |
| `:JdtJol`                   | object layout and size (Java Object Layout)        |
| `:JdtSetRuntime`            | switch the JDK runtime                             |
| `:JdtUpdateDebugConfig`     | rediscover main classes for the debugger           |

```text
 CHAPTER 5 SUMMARY
  - grn rename, then :wa
  - gra code actions (Visual for extract) ; <Space>go organize imports
  - extract: select, gra, then grn the generated name
  - picker <C-q>, then :cdo s/../../ | update   (or :cfdo per file)
```

---

## Chapter 6: Debugging

Before you start, finish Lesson 4.3 so the project compiles, and run
`<Space>br` to clear old breakpoints.

### Lesson 6.1: Breakpoints

| Keys          | Does                                                          |
| ------------- | ------------------------------------------------------------- |
| `<Space>bb`   | toggle a breakpoint                                           |
| `<Space>bc`   | conditional breakpoint (you're prompted for the condition)    |
| `<Space>bl`   | log point (prompted for the message)                          |
| `<Space>br`   | remove all breakpoints                                        |
| `<Space>ba`   | breakpoint list in a float: `o` jump, `t` enable/disable, `d` delete, `q` close |
| `<Space>db`   | breakpoint picker                                             |

  1. In `App.java`, search `/double total` and press `<Space>bb`. A sign
     appears in the sign column.

### Lesson 6.2: Start a session and tour the UI

Press `<Space>dc`. With no session running, it asks which configuration to use:

| Configuration                       | What it does                                           |
| ----------------------------------- | ------------------------------------------------------ |
| `Launch nvim-tutor: dev.tutor.App`  | auto-discovered main class                             |
| `Debug Launch (2GB)`                | launches the class **in the current buffer** with `-Xmx2g` |
| `Debug Attach (8000)` / `(5005)`    | attach to a running JVM (Lesson 6.9)                   |

Pick the first one. If it's missing, run `:JdtUpdateDebugConfig`.

dap-ui opens by itself:

```text
┌──────────────┬──────────────────────────────────┐
│ Scopes       │                                  │
├──────────────┤                                  │
│ Stacks       │            your code             │
├──────────────┤        (current line in green)   │
│ Watches      │                                  │
├──────────────┤                                  │
│ Breakpoints  │                                  │
├──────────────┴────────────┬─────────────────────┤
│ REPL                      │ Console (stdout)    │
└───────────────────────────┴─────────────────────┘
```

Move between panes with `<C-h>` `<C-j>` `<C-k>` `<C-l>`. `<Space>sm` zooms
the current pane and `<Space>sm` restores it.

### Lesson 6.3: Stepping

| Keys          | Does                                                       |
| ------------- | ---------------------------------------------------------- |
| `<Space>dc`   | continue to the next breakpoint (also starts a session)    |
| `<Space>dj`   | step over (move down a line)                               |
| `<Space>dk`   | step into                                                  |
| `<Space>do`   | step out                                                   |
| `<Space>dl`   | re-run the last configuration                              |

  1. You are stopped on the `total` line with `i = 0`. `<Space>dj` steps to `println`.
  2. `<Space>dc` stops again with `i = 1`. `<Space>dk` steps into `sumOfAreas`.
  3. `<Space>dj` twice, then `<Space>do` takes you back to `main`.

### Lesson 6.4: Inspecting state

- Variable values are shown as comments at the end of lines
  (nvim-dap-virtual-text).
- `<Space>di` evaluates the word under the cursor in a float. `<CR>` expands
  objects and `:q` closes the float.
- `<Space>d?` shows all scopes in a large centered float. Close it with `:q`.
- **Scopes** pane: `<CR>` expands, `e` **edits a value**, `r` sends to the
  REPL, `w` adds to Watches.
- **Watches** pane: press `i`, type an expression and `<CR>`. It's
  re-evaluated at every stop. `e` edits, `d` deletes.
- **Stacks** pane: `o` jumps to a frame and `t` toggles JDK-internal frames.
  `<Space>df` is a frame picker.
- `<Space>dh` is a picker of every debugger command, for when you forget a key.

  1. `<Space>di` on `shapes`, `<CR>` to expand, `:q`.
  2. Go to Watches and add `service.price(i)`. Press `<Space>dc` a few times
     and watch it change.
  3. In Scopes, put the cursor on `i`, press `e` and set it to `8`. Then `<Space>dc`.

### Lesson 6.5: Conditional breakpoints and log points

  1. `<Space>dt` stops the session. On the `double total` line, press
     `<Space>bb` to remove the plain breakpoint, then `<Space>bc` and type
     `i == 7`.
  2. `<Space>dl` reruns. It stops only when `i` is 7 (check Scopes). Then `<Space>dt`.
  3. On the `System.out.println` line, `<Space>bl` and type `log point: i={i}`.
     Expressions in `{}` are evaluated. Run with `<Space>dl`: the messages
     appear in the REPL and execution doesn't stop.
  4. `<Space>ba` lists all breakpoints. `d` deletes the conditional one and `q` closes.

### Lesson 6.6: The debug REPL

`<Space>dr` toggles the REPL, which is also in the bottom tray. Press `i` to
type:

- any Java expression in the current frame: `service.price(42)`, `shapes.size()`
- commands: `.n` (next), `.c` (continue), `.into`, `.out`, `.up`, `.down`,
  `.frames`, `.scopes`, `.threads`, `.help`

### Lesson 6.7: Hot code replace

Your jdtls setup uses `hotcodereplace = "auto"`. While the program is paused,
edit a method body and `:w`. The class is reloaded in the running JVM.

  1. Stop in the loop (breakpoint on `double total`, then `<Space>dc`).
  2. In `OrderService.sumOfAreas`, change `sum += shape.area();` to
     `sum += shape.area() * 2;` and `:w`.
  3. `<Space>dc` a few times. The totals in the Console double.
  4. Undo the change, `:w`, then `<Space>dt`.

Only method bodies can change this way. New methods, new fields or signature
changes need a restart (`<Space>dt`, then `<Space>dl`). `:JdtUpdateHotcode`
triggers a reload manually.

### Lesson 6.8: Debug an HTTP endpoint (kulala)

After the loop, `App` serves `GET /price?qty=N` on port 8080.

  1. `<Space>br`. In `App.java`, search `/int qty` and press `<Space>bb`.
  2. `<Space>dc` and the launch config. The Console shows `Listening on ...`.
  3. Open `requests.http` (`<Space>f`, then `requests`), put the cursor on the
     first request and press `<CR>` (or `<Space>Rs`).
  4. The breakpoint hits. Press `<Space>dj`; the virtual text shows `qty = 3`.
  5. In Scopes, `e` on `qty` sets it to `30`. Then `<Space>dc`.
  6. The kulala window shows `{"qty":30, ...}`.

Keys in the kulala **response window**: `B` body, `H` headers, `A` both,
`V` verbose, `S` stats, `[` / `]` previous / next response, `?` help, `q` close.

Keys in **`.http` files**:

| Keys                       | Does                               |
| -------------------------- | ---------------------------------- |
| `<CR>` / `<Space>Rs`       | send the request under the cursor  |
| `<Space>Ra`                | send all requests                  |
| `<Space>Rr`                | replay the last request            |
| `<Space>Rn` / `<Space>Rp`  | jump to the next / previous request |
| `<Space>Rf`                | find a request                     |
| `<Space>Rc` / `<Space>RC`  | copy as cURL / paste from cURL     |
| `<Space>Re`                | select an environment              |
| `<Space>Ri`                | inspect the request                |
| `<Space>Rt`                | toggle headers / body              |
| `<Space>Ro` / `<Space>Rq`  | open / close the kulala window     |
| `<Space>Rb`                | scratchpad                         |

Finish with `<Space>dt`, which also stops the server.

### Lesson 6.9: Attach to a running JVM

`Debug Attach (5005)` and `Debug Attach (8000)` connect to `127.0.0.1`.

  1. Open a tmux pane next to Neovim (`<C-b>%`) and run:

     ```bash
     cd ~/nvim-tutor && mvn -q compile && \
       java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005 \
            -cp target/classes dev.tutor.App
     ```

     `suspend=y` makes the JVM wait for the debugger.
  2. `<C-h>` takes you back to Neovim (it crosses tmux panes). Set a
     breakpoint in the loop, then `<Space>dc` and choose `Debug Attach (5005)`.
  3. The breakpoint hits. Program output goes to the tmux pane, not to the
     Console.
  4. `<Space>dd` **disconnects**: the app keeps running. Stop it with `<C-c>`
     in the pane.

Ways to start real projects with a debug port:

| Situation                     | Command                                                                                  | Port |
| ----------------------------- | ---------------------------------------------------------------------------------------- | ---- |
| Spring Boot (Maven)           | `mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"` | 5005 |
| Spring Boot (Gradle)          | `./gradlew bootRun --debug-jvm` (waits for the debugger)                                 | 5005 |
| Maven tests                   | `mvn test -Dmaven.surefire.debug` (waits for the debugger)                               | 5005 |
| Gradle tests                  | `./gradlew test --debug-jvm`                                                             | 5005 |
| The Maven JVM itself          | `mvnDebug <goals>` (plugins, `exec:java`)                                                | 8000 |
| Any JVM or container          | add `-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005` and publish the port | 5005 |

### Lesson 6.10: Ending a session

| Keys          | Does                                                          |
| ------------- | ------------------------------------------------------------- |
| `<Space>dt`   | terminate the program and close dap-ui                        |
| `<Space>dd`   | disconnect (detach) and close dap-ui. Use it for attach sessions |
| `<Space>dl`   | run the last configuration again                              |

dap-ui opens by itself but does **not** close when the program ends.
`<Space>dt` closes it even when no session is running.

```text
 CHAPTER 6 SUMMARY
  - <Space>bb toggle, bc condition, bl log point {expr}, br clear, ba list, db picker
  - <Space>dc start/continue, dj over, dk into, do out, dl rerun
  - <Space>di hover value, d? scopes, df frames, dh commands, dr REPL
  - Scopes: e edit value, w watch ; Watches: i add ; Stacks: o jump
  - save while paused = hot code replace
  - kulala: <CR> in .http sends the request and hits the breakpoint
  - attach: jdwp on 5005/8000, then <Space>dc ; <Space>dd detach ; <Space>dt kill and close
```

---

## Chapter 7: Running and debugging tests

### Lesson 7.1: Run a test class

Open `src/test/java/dev/tutor/OrderServiceTest.java` and press `<Space>tc`.

Tests run **under the debugger**, so dap-ui opens. When they finish:

- `✓` or `✗` appears next to each test method.
- The message reads `Tests finished. Results printed to dap-repl. Errors added
  to quickfix list (✗ 1 / 2)`.
- Failures are in the quickfix list. `<Space>qo`, then `<CR>` on the entry
  jumps to the failing assertion.

### Lesson 7.2: Fix it and rerun the nearest test

  1. On the failing `assertEquals(100.0, ...)` line, type `f1`, `ct,`, then
     `215.784` and `<Esc>`.
  2. Delete the `// TUTOR:` comment above it with `k` and `dd`.
  3. With the cursor inside `bulkDiscountApplies`, press `<Space>tm` (nearest
     method). It gets a `✓`.
  4. `<Space>qc` closes the quickfix list and `<Space>dt` closes dap-ui.

### Lesson 7.3: Debug a test

  1. In `OrderService.price`, `<Space>bb` on the `return` line.
  2. Back in the test, cursor inside `priceOfOneItemIncludesTax`, then `<Space>tm`.
  3. It stops in `price`. Inspect with `<Space>di`, then `<Space>dc`, then `<Space>dt`.

### Lesson 7.4: Write a new test quickly

Below the last test, type the method below using autopairs and completion
(`assertEq` completes):

```java
    @Test
    void zeroQuantityIsFree() {
        assertEquals(0.0, service.price(0), 0.0001);
    }
```

Then `<Space>tm` inside it. Your `favoriteStaticMembers` setting lets
`assertThat`, `assertEquals`, Mockito's `mock` and `when`, and similar static
members complete with an automatic static import. `mvn test` works from the
shell too.

```text
 CHAPTER 7 SUMMARY
  - <Space>tc test class, <Space>tm nearest test (Java buffers only)
  - ✓ / ✗ marks, details in the dap REPL, failures in quickfix (<Space>qo)
  - breakpoints work in tests and in code under test ; <Space>dt closes the UI
```

---

## Chapter 8: Git

First commit your progress: `:!git add -A && git commit -qm "Tutor progress"`.

### Lesson 8.1: gitsigns

Changed lines get signs in the sign column. `<Space>gb` opens a blame panel
for the whole file; close it with `<Space>sx`.

There are no other gitsigns mappings in your config. Use the commands
(`<Tab>` completes them):

| Command                               | Does                                     |
| ------------------------------------- | ---------------------------------------- |
| `:Gitsigns preview_hunk`              | show the hunk diff in a float            |
| `:Gitsigns preview_hunk_inline`       | show it inline                           |
| `:Gitsigns nav_hunk next` / `prev`    | jump between hunks                       |
| `:Gitsigns stage_hunk` / `reset_hunk` | stage / discard the hunk                 |
| `:Gitsigns blame_line`                | commit info for the current line         |
| `:Gitsigns toggle_current_line_blame` | blame as virtual text                    |
| `:Gitsigns diffthis`                  | diff the file against the index in a split |
| `:Gitsigns setqflist`                 | send all hunks to quickfix               |

  1. In `App.java`, change the `println` text and look at the sign.
  2. `:Gitsigns preview_hunk`, then `:Gitsigns reset_hunk`.

### Lesson 8.2: Review and stage with Diffview

| Command                        | Does                                         |
| ------------------------------ | -------------------------------------------- |
| `:DiffviewOpen`                | working tree vs index, in a **new tab**      |
| `:DiffviewOpen HEAD~1`         | compare against any revision                 |
| `:DiffviewFileHistory %`       | history of the current file                  |
| `:DiffviewFileHistory`         | history of the repository                    |
| `:DiffviewClose`               | close (`<Space>tx` also works)               |

| Keys inside Diffview          | Does                                          |
| ----------------------------- | --------------------------------------------- |
| `<Tab>` / `<S-Tab>`           | next / previous file                          |
| `-` or `s` (file panel)       | stage / unstage the file                      |
| `S` / `U`                     | stage all / unstage all                       |
| `X`                           | restore the file (**discards** changes)       |
| `<Space>e` / `<Space>b`       | focus / toggle the file panel                 |
| `gf`                          | open the file in the previous tab             |
| `g<C-x>`                      | cycle layouts                                 |
| `g?`                          | help                                          |
| `]c` / `[c` (`<Space>cn` / `<Space>cp`) | next / previous hunk                |
| `do` / `dp` (`<Space>cc` = `:diffput`)  | get / put a hunk between windows    |

  1. Change one line in `App.java` and one in `OrderService.java`, then `:wa`.
  2. `:DiffviewOpen`. `<Tab>` between files and `<Space>cn` between hunks.
  3. In the file panel, press `-` on `App.java` to stage it. Then `:DiffviewClose`.
  4. `:!git status -s` shows one staged and one unstaged file.

### Lesson 8.3: Resolve a merge conflict

This script creates a conflict on the tax rate. Select from `cd` to `git merge`
with `V`, then `:w !bash` (as in Lesson 0.2), or paste it into a shell:

```bash
cd ~/nvim-tutor && git add -A && git commit -qm "Tutor progress"
git checkout -q -b raise-tax && sed -i 's/= 0.2;/= 0.25;/' src/main/java/dev/tutor/OrderService.java && git commit -qam "Raise tax"
git checkout -q - && sed -i 's/= 0.2;/= 0.18;/' src/main/java/dev/tutor/OrderService.java && git commit -qam "Lower tax"
git merge raise-tax
```

  1. `:checktime` reloads the changed files. Then `:DiffviewOpen`. The
     conflicted file is listed under *Conflicts*.
  2. Open it. The layout (`diff3_mixed`) shows OURS and THEIRS on top and the
     result below.
  3. `]x` / `[x` move between conflicts. Choose a side:

| Keys                        | Takes                                       |
| --------------------------- | ------------------------------------------- |
| `<Space>co` / `<Space>ct`   | OURS / THEIRS                               |
| `<Space>cb` / `<Space>ca`   | BASE / all of them                          |
| `dx`                        | none (deletes the conflict region)          |
| `<Space>cO` `<Space>cT` `<Space>cB` `<Space>cA` `dX` | the same for the whole file |

  4. `:w`, `-` in the file panel to stage, `:DiffviewClose`, then
     `:!git commit --no-edit`.

In a classic `git mergetool` / `nvim -d` session, your own keys apply:
`<Space>cj` runs `:diffget 1` (LOCAL), `<Space>ck` runs `:diffget 3` (REMOTE),
`<Space>cc` runs `:diffput`, and `<Space>cn` / `<Space>cp` move between hunks.

```text
 CHAPTER 8 SUMMARY
  - signs in the sign column ; <Space>gb blame panel ; :Gitsigns preview_hunk / reset_hunk / nav_hunk
  - :DiffviewOpen [rev] ; :DiffviewFileHistory % ; :DiffviewClose
  - Diffview: <Tab> files, - stage, S/U all, ]c [c hunks
  - conflicts: ]x [x, <Space>co / ct / cb / ca, dx ; uppercase = whole file
```

---

## Chapter 9: Sessions and odds and ends

| What                                   | How                                                  |
| -------------------------------------- | ---------------------------------------------------- |
| Record a session (vim-obsession)       | `:Obsess` writes `Session.vim` in the cwd and keeps it updated |
| Restore a session                      | `nvim -S Session.vim`. tmux-resurrect also restores Neovim from it (`@resurrect-strategy-nvim 'session'`) |
| Stop recording                         | `:Obsess!`                                           |
| Search every mapping                   | `:lua Snacks.picker.keymaps()` (which-key isn't installed) |
| Raw mapping list                       | `:map <Space>`, `:verbose map <Space>ff`             |
| Missed a message?                      | `:messages`, `:lua Snacks.notifier.show_history()`   |
| Plugins / LSP servers / health         | `:Lazy`, `:Mason`, `:checkhealth`                    |
| Spelling (markdown)                    | `]s` / `[s` next / previous error, `z=` suggest, `zg` add word |

`cmdheight=0` hides the command line until you need it, so messages can
disappear quickly. Use the commands above to see them again.

---

## Appendix A: Cheat sheet

### General, windows, tabs

| Keys | Action | Keys | Action |
| --- | --- | --- | --- |
| `<Space>ww` | save | `<Space>sv` / `ss` | split vertical / horizontal |
| `<Space>wq` | save and quit | `<Space>sx` | close split |
| `<Space>qq` | quit, **discard changes** | `<Space>se` | equalize splits |
| `<Space>to` / `tx` | new / close tab | `<Space>sh` / `sl` | narrower / wider |
| `<Space>tn` / `tp` | next / previous tab | `<Space>sj` / `sk` | shorter / taller |
| `<C-h/j/k/l>` | move between splits and tmux panes | `<Space>sm` | zoom toggle |
| `<C-\>` | previous split or pane | `<Space>qo` / `qc` | open / close quickfix |

### Finding

| Keys | Action | Keys | Action |
| --- | --- | --- | --- |
| `<Space>f` (wait) | smart picker | `<Space>ee` / `er` | explorer at the cwd |
| `<Space>ff` | files near the current file | `<Space>ef` | explorer, current file revealed |
| `<Space>fg` | grep | `<Space>ft` | grep in a directory (from the explorer) |
| `<Space>fb` | buffers | `<Space>fo` | LSP symbols |
| `<Space>fs` | lines in the buffer | `<Space>fm` | methods (treesitter) |
| `<Space>fh` | help | `<Space>fi` | incoming calls |

### Code (LSP and jdtls)

| Keys | Action | Keys | Action |
| --- | --- | --- | --- |
| `K` | hover | `grn` | rename |
| `<C-]>` / `<C-t>` | definition / back | `gra` | code action (Normal and Visual) |
| `<Space>gD` | declaration | `grr` | references |
| `grt` | type definition | `gri` | implementations |
| `gO` | outline (location list) | `<Space>gf` | format (Normal and Visual) |
| `<Space>gs` / `<C-s>` (Insert) | signature help | `<Space>go` | organize imports (Java) |
| `]d` / `[d` | next / previous diagnostic | `<Space>gu` | update project config (Java) |
| `]D` / `[D` | last / first diagnostic | `<Space>de` | error diagnostics picker |
| `<C-w>d` | diagnostic float | `<Space>gb` | git blame |

### Insert mode and editing

| Keys | Action | Keys | Action |
| --- | --- | --- | --- |
| `<C-j>` / `<Tab>` | next completion | `gcc` / `gc{motion}` | comment |
| `<C-k>` / `<S-Tab>` | previous completion | `sa{motion}{c}` | add a surrounding |
| `<CR>` | accept completion | `sd{c}` / `sr{o}{n}` | delete / replace a surrounding |
| `<C-e>` | dismiss completion | `af` `if` `ac` `ic` `aa` `ia` | method / class / argument objects |
| `<C-Space>` | trigger LSP completion | Visual `an` / `in` | grow / shrink the selection |
| `<Tab>` / `<S-Tab>` | snippet jump (no menu) | `]<Space>` / `[<Space>` | blank line below / above |

### Debug and test

| Keys | Action | Keys | Action |
| --- | --- | --- | --- |
| `<Space>bb` | toggle breakpoint | `<Space>dc` | start / continue |
| `<Space>bc` | conditional breakpoint | `<Space>dj` | step over |
| `<Space>bl` | log point | `<Space>dk` | step into |
| `<Space>br` | clear breakpoints | `<Space>do` | step out |
| `<Space>ba` | breakpoint float | `<Space>dl` | run last |
| `<Space>db` | breakpoint picker | `<Space>dt` | terminate and close UI |
| `<Space>di` | hover value | `<Space>dd` | disconnect and close UI |
| `<Space>d?` | scopes float | `<Space>dr` | toggle REPL |
| `<Space>df` | frames picker | `<Space>dh` | DAP commands picker |
| `<Space>tc` | test class (Java) | `<Space>tm` | nearest test (Java) |

### Diff, merge, HTTP

| Keys | Action | Keys | Action |
| --- | --- | --- | --- |
| `<Space>cn` / `cp` | next / previous hunk | `<Space>Rs` / `<CR>` | send request |
| `<Space>cc` | `:diffput` | `<Space>Ra` | send all requests |
| `<Space>cj` / `ck` | `:diffget 1` / `:diffget 3` | `<Space>Rr` | replay last request |
| `]x` / `[x` | next / previous conflict (Diffview) | `<Space>Rn` / `Rp` | next / previous request |
| `<Space>co` / `ct` / `cb` / `ca` | ours / theirs / base / all (Diffview) | `<Space>Rc` / `RC` | copy / paste cURL |

## Appendix B: Gotchas in this config

1. `<Space>f` waits about 1 s because it's a prefix of `ff`, `fg` and the rest.
2. `<Space>ff` searches from the **current file's directory**. Use
   `<Space>f` or `<Space>fg` for the whole project.
3. `<C-l>` moves to the right split (tmux navigator) instead of clearing the
   search highlight. Use `:noh`.
4. `s` is the mini.surround prefix. Use `cl` to substitute a character.
5. `-` is part of a word: `w`, `*` and `ciw` treat `count-1` as one word.
6. With the completion menu open, `<CR>` accepts. Press `<C-e>` first for a
   newline.
7. Deletes overwrite the system clipboard. `"0p` pastes the last yank and
   `"_d` deletes without copying.
8. `<Space>qq` discards unsaved changes.
9. Renames and refactors can leave modified buffers. Run `:wa`.
10. `<Space>go`, `<Space>gu`, `<Space>tc` and `<Space>tm` exist only in Java
    buffers.
11. `Debug Launch (2GB)` debugs the class in the **current buffer**.
12. dap-ui doesn't close by itself. `<Space>dt` closes it at any time.
13. hardtime blocks repeated `hjkl` and arrow keys. Use counts and motions,
    or `:Hardtime toggle`.

```text
 ================================================================
   This concludes the Java NVIMTUTOR. Repeat a chapter whenever a
   key doesn't come automatically yet. Run the setup script in
   Lesson 0.2 again to reset the playground.
 ================================================================
```
