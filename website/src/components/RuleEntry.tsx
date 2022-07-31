import React from 'react';
import CopyButton from './buttons/CopyButton';

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
  const severityLover = severity?.toLowerCase();
  const href = `${type}/${name}`;

  return (
    <div className="rule-entry">
      <div className="rule-content">
        <a className="rule-link" href={href}>
          <span>{name}</span>
          <CopyButton link={href} />
        </a>

        <p className="rule-description">{children}</p>

        <div className="rule-additional-info">
          <div>added in: {version}</div>

          <div className={`rule-severity ${severityLover}`}>
            {severityLover}
          </div>

          <div className="rule-options">
            {hasConfig && <span title="Configurable">⚙️</span>}

            {hasFix && <span title="Has auto-fix">🛠</span>}

            {isDeprecated && <span title="Deprecated">⚠️</span>}
          </div>
        </div>
      </div>
    </div>
  );
}
