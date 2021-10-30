import React from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import Logo from '../../static/img/logo.svg';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import styles from './index.module.css';
import HomepageFeatures from '../components/HomepageFeatures';
import GitHubButton from 'react-github-btn';

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx('hero', styles.heroBanner)}>
      <div className={clsx('container', styles.heroContainer)}>
        <Logo className={styles.logo} />

        <div className={clsx(styles.heroContainerCaption)}>
          <h1 className="hero__title">{siteConfig.title}</h1>
          <p className="hero__subtitle">
            Analyse and improve your code quality.
          </p>
          <div className={styles.buttons}>
            <Link
              className="button button--primary button--lg"
              to="/docs/getting-started/introduction"
            >
              Get Started
            </Link>

            <span className={styles.githubButton}>
              <GitHubButton
                href="https://github.com/dart-code-checker/dart-code-metrics"
                data-size="large"
                data-show-count="true"
                aria-label="Star dart-code-checker/dart-code-metrics on GitHub"
              >
                Star
              </GitHubButton>
            </span>
          </div>
        </div>
      </div>
    </header>
  );
}

export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout description={siteConfig.tagline}>
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}
