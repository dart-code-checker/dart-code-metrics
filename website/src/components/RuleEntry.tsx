import React from 'react';
import RuleAdditionalInfo from './rule/RuleAdditionalInfo';
import RuleId from './rule/RuleId';

type Props = {
  name: string;
  type: string;
  version: string;
  severity: string;
  children: React.ReactNode;
  hasConfig: boolean;
  hasFix: boolean;
  isDeprecated: boolean;
};

export default function RuleEntry({
  name,
  type,
  version,
  severity,
  children,
  hasConfig,
  hasFix,
  isDeprecated,
}: Props) {
  const href = `rules/${type}/${name}`;

  return (
    <div className="rule-entry">
      <div className="rule-content">
        <a className="rule-link" href={href}>
          <RuleId name={name} />
        </a>

        <p className="rule-description">{children}</p>

        <RuleAdditionalInfo
          version={version}
          severity={severity}
          hasConfig={hasConfig}
          hasFix={hasFix}
          isDeprecated={isDeprecated}
        />
      </div>
    </div>
  );
}
