import React from 'react';
import RuleOptions from './RuleOptions';

export default function RuleAdditionalInfo({
  severity,
  version,
  hasConfig,
  hasFix,
  isDeprecated,
}) {
  const severityLover = severity?.toLowerCase();

  return (
    <div className="rule-additional-info">
      <div>
        <span className="added-in-label">added in:</span> {version}
      </div>

      <div className={`rule-severity ${severityLover}`}>{severityLover}</div>

      <RuleOptions
        hasConfig={hasConfig}
        hasFix={hasFix}
        isDeprecated={isDeprecated}
      />
    </div>
  );
}
