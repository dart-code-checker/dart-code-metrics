import React from 'react';
import CopyButton from '../buttons/CopyButton';

export default function RuleId({ name }) {
  return (
    <div>
      <span>{name}</span>
      <CopyButton link={name} />
    </div>
  );
}
