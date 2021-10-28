const c = 42;

const bad1 = 1 + c; // LINT
const bad2 = c + (1 + c); // LINT
const bad3 = c + (12.44 * c); // LINT
const bad4 = 1 & c; // LINT
const bad5 = 2 | c; // LINT
const bad6 = 4 ^ c; // LINT

const good1 = c + 1;
const good2 = c + (c + 1);
const good3 = c + (c * 12.44);
const good4 = c & 1;
const good5 = c | 2;
const good6 = c ^ 4;

const skip1 = 100 - c;
const skip2 = 168 / c;
const skip3 = 168 / (84 - c);
