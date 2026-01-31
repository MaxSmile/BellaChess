import { NextRequest, NextResponse } from 'next/server';

// Mock chess engine API endpoint
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { fen, difficulty } = body;

    // This would normally communicate with a chess engine like Stockfish
    // For now, we'll return a mock response
    const mockBestMove = generateMockMove(fen);
    
    return NextResponse.json({ 
      bestMove: mockBestMove,
      evaluation: calculatePositionEvaluation(fen),
      depth: difficulty || 5
    });
  } catch (error) {
    return NextResponse.error();
  }
}

// Helper functions for mock responses
function generateMockMove(fen: string): string {
  // In a real implementation, this would interface with a chess engine
  const possibleMoves = ['e2e4', 'd2d4', 'g1f3', 'c2c4', 'e7e5', 'd7d5', 'g8f6', 'c7c5'];
  return possibleMoves[Math.floor(Math.random() * possibleMoves.length)];
}

function calculatePositionEvaluation(fen: string): number {
  // Simplified position evaluation (-1.0 to 1.0 scale)
  // Positive values favor white, negative favor black
  return Math.random() * 2 - 1; // Random value between -1 and 1 for demo
}