import React from 'react';
import './globals.css';
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import Script from 'next/script';
import TelemetryProvider from '@/components/TelemetryProvider';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'BellaChess - Learn, Play, and Collect Chess Masterpieces',
  description: 'AI-powered chess platform with etude challenges and NFT collectibles',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const ga4Id = process.env.NEXT_PUBLIC_GA4_ID;

  return (
    <html lang="en">
      <head>
        {ga4Id ? (
          <>
            <Script
              src={`https://www.googletagmanager.com/gtag/js?id=${ga4Id}`}
              strategy="afterInteractive"
            />
            <Script id="ga4-init" strategy="afterInteractive">
              {`
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                window.gtag = gtag;
                gtag('js', new Date());
                gtag('config', '${ga4Id}', { anonymize_ip: true });
              `}
            </Script>
          </>
        ) : null}
      </head>
      <body className={inter.className}>
        <TelemetryProvider />
        {children}
      </body>
    </html>
  );
}
