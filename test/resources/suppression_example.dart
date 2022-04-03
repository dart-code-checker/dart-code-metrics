// ignore_for_file:rule_id1

void main() {
  // ignore: rule_id4
  const a = 5; // ignore: RULE_ID5

  // ignore comment
  // ignore:rule_id6 ,rule_id7, some comment about ignores
  const b = a + 5; // ignore: RULE_ID8, rule_id9, unused_local_variable
}

// ignore_for_file: rule_id2 , RULE_ID3
