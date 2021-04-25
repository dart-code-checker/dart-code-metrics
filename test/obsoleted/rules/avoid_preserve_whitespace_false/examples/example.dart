@Component(
  selector: 'component-selector',
  templateUrl: 'component.html',
  styleUrls: ['component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  preserveWhitespace: false, // LINT
  directives: <Object>[
    coreDirectives,
  ],
)
class Component {}

@Component(
  selector: 'component2-selector',
  templateUrl: 'component2.html',
  styleUrls: ['component2.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: <Object>[
    coreDirectives,
  ],
)
class Component2 {}

@Component(
  selector: 'component3-selector',
  templateUrl: 'component3.html',
  styleUrls: ['component3.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  preserveWhitespace: true,
  directives: <Object>[
    coreDirectives,
  ],
)
class Component3 {}
