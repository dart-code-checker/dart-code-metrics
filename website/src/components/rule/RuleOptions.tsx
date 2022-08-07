import React from 'react';

export default function RuleOptions({ hasConfig, hasFix, isDeprecated }) {
  return (
    <div className="rule-options">
      {hasConfig && <span title="Configurable">⚙️</span>}

      {hasFix && <span title="Has auto-fix">🛠</span>}

      {isDeprecated && <span title="Deprecated">⚠️</span>}
    </div>
  );
}
