import React from 'react';
import clsx from 'clsx';
import styles from './HomepageFeatures.module.css';

const FeatureList = [
  {
    title: 'Improve your code quality',
    Svg: require('../../static/img/quality.svg').default,
    description: (
      <>
        Dart Code Metrics checks for anti-patterns and reports code metrics to
        help you monitor the quality of your code and improve it.
      </>
    ),
  },
  {
    title: 'Additional rules',
    Svg: require('../../static/img/rules.svg').default,
    description: (
      <>
        Dart Code Metrics provides additional configurable rules for the Dart
        analyzer.
      </>
    ),
  },
  {
    title: 'Use as Analyzer plugin',
    Svg: require('../../static/img/plugin.svg').default,
    description: (
      <>
        Connecting Dart Code Metrics as a plugin to the Analysis Server allows
        you to receive real-time feedback directly from the IDE.
      </>
    ),
  },
  {
    title: 'Integrate into the CI/CD process',
    Svg: require('../../static/img/ci.svg').default,
    description: (
      <>
        Launching via the command line allows you to easily integrate Dart Code
        Metrics into the CI/CD process, and you can get results in Сonsole,
        HTML, JSON, CodeClimate, or GitHub.
      </>
    ),
  },
  {
    title: 'Community-friendly',
    Svg: require('../../static/img/feedback.svg').default,
    description: (
      <>
        Dart Code Metrics is developed by community for community. Your feedback
        and PRs won't be ignored.
      </>
    ),
  },
];

function Feature({ Svg, title, description }) {
  return (
    <div className={clsx('col col--4', styles.feature)}>
      <div className="text--center">
        <Svg className={styles.featureSvg} alt={title} />
      </div>
      <div className="text--center padding-horiz--md">
        <h2>{title}</h2>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className={clsx('row', styles.featuresRow)}>
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
