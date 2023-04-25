import { Helmet } from 'react-helmet-async';

type InitType = {
  children: JSX.Element;
};

export default function Init({ children }: InitType) {
  return (
    <>
      {children}
      <Helmet>
        <link rel="icon" href={`favicon-dark.ico`} />
      </Helmet>
    </>
  );
}
