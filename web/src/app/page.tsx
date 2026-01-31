'use client';

import React from 'react';
import ChessBoard from '@/components/ChessBoard';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-gray-900">BellaChess</h1>
        </div>
      </header>
      <main>
        <div className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
          <div className="px-4 py-6 sm:px-0">
            <div className="bg-white rounded-lg p-6 shadow-md">
              <h2 className="text-2xl font-semibold mb-4 text-center">Play Chess</h2>
              <div className="flex justify-center">
                <ChessBoard />
              </div>
            </div>
            
            <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="bg-white p-6 rounded-lg shadow-md">
                <h3 className="text-xl font-semibold mb-2">AI Coach</h3>
                <p>Get personalized feedback and improve your game with our AI-powered coach.</p>
              </div>
              
              <div className="bg-white p-6 rounded-lg shadow-md">
                <h3 className="text-xl font-semibold mb-2">Etude Challenges</h3>
                <p>Solve tactical puzzles and master chess patterns with our progressive etude system.</p>
              </div>
              
              <div className="bg-white p-6 rounded-lg shadow-md">
                <h3 className="text-xl font-semibold mb-2">NFT Collectibles</h3>
                <p>Earn unique digital collectibles based on your achievements and victories.</p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}