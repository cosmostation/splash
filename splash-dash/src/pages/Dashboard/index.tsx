import Content from './content';
import ContentContainer from 'src/components/ContentContainer';
import Layout from 'src/components/Layout';

export default function Main() {
  return (
    <Layout>
      <ContentContainer>
        <Content />
      </ContentContainer>
    </Layout>
  );
}
