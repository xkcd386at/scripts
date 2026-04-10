# f9 README + test input file

**NOTE**: No AI was used in writing this program.  Not for the code, not for the readme, not for anything else.

F9 is a stupid simple "mini spreadsheet" inside a markdown table.  It can compute based on values in **previous** cells only (i.e., cells in earlier rows, or cells to the left in the same row).  That is how stupid it is.

Why?

-   I'm often without my laptop for days on end, so XLS/ODS is no use
-   My actual "spreadsheet" needs when I am away from my laptop **are** stupid simple
-   Almost every other piece of data I have is in markdown already so why not this also?

Formulas are placed inside HTML comments within a cell, like this: `| <!-- L1*1.18 --> |`.  If the cell **one** position to the **left** (hence L1) has the value 100, then, after running this code on the file, this cell will become `| <!-- L1*1.18 --> 118 |`.

Any markdown renderer should work fine.  I use these and they all work fine (i.e., ignore the HTML comment):

-   Markor app on Android in "view" mode
-   Pandoc generating HTML (both on Termux in Android, and on Linux)
-   Okular app on Linux

This README serves as a permanent "test" input, as well as a demo.  To test:

    f9.pl < f9-README.md | diff -u -- f9-test-output.md
    # should show no differences

Anyway, on to the test/demo (data and formulas are silly/contrived).

<!-- F9 RT = L1 + UL0 -->
<!-- F9 GST = L2 * 0.18 -->

| date       | something     | running total | GST           | notes |
| ---        | ---           | ----          | ----          | ---- |
| 2026-04-10 | 10            | <!-- =RT -->  | <!-- =GST --> | blah |
| 2026-04-11 | 20            | <!-- =RT -->  | <!-- =GST --> | blah blah |
| 2026-04-11 | 30            | <!-- =RT -->  | <!-- =GST --> | more blah blah |
| 2026-04-14 | 42            | <!-- =RT -->  | <!-- =GST --> | |
|            | <!-- =SUM --> | <!-- =UL0 --> | <!-- =UL0 --> | First two totals must match |

(You should look at f9-test-output.md for the result.  If you're seeing this on github, [here](./f9-test-output.md).)

Some points to note:

-   one blank line between the `<!-- f9 ...` and the actual table
    -   all the renderers **I** care about work fine without; only github doesn't.
-   every table line *must* start with a `|`
-   formulas can be pre-declared in an "F9" line, as the two lines before the table show.
    -   you don't have to, but it's more convenient if you do.
    -   if you're viewing this on github, switch to raw mode to see those lines
-   formulas can use
    -   `SUM`, which sums the current column from row 1 to the previous row
    -   `L\d`, e.g., `L2`, which is "2 cells to the left" of this cell
    -   `UL\d`, e.g., `UL1`, which is "previous row, one column to the left"
        -   `UL0` is cell just above
        -   only the previous row is visible; rows above that one are not
        -   `UR\d` is also allowed (e.g., `UR2` is previous row, two columns to the right")
    -   any cells referenced which do not exist or do not have a valid number will be treated as `0`.
