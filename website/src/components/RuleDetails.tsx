import React from 'react';
import RuleAdditionalInfo from './rule/RuleAdditionalInfo';

export default function RuleDetails({
  version,
  severity,
  hasConfig,
  hasFix,
  isDeprecated,
}) {
  return (
    <div className="single-rule-info">
      <RuleAdditionalInfo
        version={version}
        severity={severity}
        hasConfig={hasConfig}
        hasFix={hasFix}
        isDeprecated={isDeprecated}
      />
    </div>
  );
}
