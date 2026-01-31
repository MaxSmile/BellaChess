'use client';

import React, { useState } from 'react';

interface Piece {
  type: 'pawn' | 'rook' | 'knight' | 'bishop' | 'queen' | 'king';
  color: 'white' | 'black';
}

const initialBoard = (): (Piece | null)[][] => {
  // Initialize the chess board with pieces in starting positions
  const board: (Piece | null)[][] = Array(8).fill(null).map(() => Array(8).fill(null));
  
  // Set up pawns
  for (let i = 0; i < 8; i++) {
    board[1][i] = { type: 'pawn', color: 'black' };
    board[6][i] = { type: 'pawn', color: 'white' };
  }
  
  // Set up other pieces
  const backRow: ('rook' | 'knight' | 'bishop' | 'queen' | 'king')[] = 
    ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook'];
    
  for (let i = 0; i < 8; i++) {
    board[0][i] = { type: backRow[i], color: 'black' };
    board[7][i] = { type: backRow[i], color: 'white' };
  }
  
  return board;
};

const ChessBoard = () => {
  const [board, setBoard] = useState<(Piece | null)[][]>(initialBoard());
  const [selectedSquare, setSelectedSquare] = useState<[number, number] | null>(null);
  const [currentPlayer, setCurrentPlayer] = useState<'white' | 'black'>('white');

  const handleSquareClick = (row: number, col: number) => {
    // Basic square selection logic
    if (selectedSquare) {
      // Move the selected piece to this square
      const [selectedRow, selectedCol] = selectedSquare;
      const newBoard = [...board.map(r => [...r])];
      
      if (newBoard[selectedRow][selectedCol]?.color === currentPlayer) {
        // Move the piece
        newBoard[row][col] = newBoard[selectedRow][selectedCol];
        newBoard[selectedRow][selectedCol] = null;
        
        setBoard(newBoard);
        setCurrentPlayer(currentPlayer === 'white' ? 'black' : 'white');
      }
      
      setSelectedSquare(null);
    } else {
      // Select a square if it contains a piece of the current player
      const clickedPiece = board[row][col];
      if (clickedPiece && clickedPiece.color === currentPlayer) {
        setSelectedSquare([row, col]);
      }
    }
  };

  const getPieceSymbol = (piece: Piece | null): string => {
    if (!piece) return '';
    
    const symbols: Record<string, Record<string, string>> = {
      white: {
        king: '♔', queen: '♕', rook: '♖', bishop: '♗', knight: '♘', pawn: '♙'
      },
      black: {
        king: '♚', queen: '♛', rook: '♜', bishop: '♝', knight: '♞', pawn: '♟'
      }
    };
    
    return symbols[piece.color][piece.type];
  };

  return (
    <div className="flex flex-col items-center justify-center p-4">
      <div className="text-xl font-bold mb-4">BellaChess Board</div>
      <div className="grid grid-cols-8 border-2 border-gray-800">
        {board.map((row, rowIndex) => 
          row.map((piece, colIndex) => {
            const isSelected = selectedSquare && selectedSquare[0] === rowIndex && selectedSquare[1] === colIndex;
            const isLightSquare = (rowIndex + colIndex) % 2 === 0;
            
            return (
              <div
                key={`${rowIndex}-${colIndex}`}
                onClick={() => handleSquareClick(rowIndex, colIndex)}
                className={`
                  w-12 h-12 md:w-16 md:h-16 flex items-center justify-center
                  ${isLightSquare ? 'bg-amber-200' : 'bg-amber-800'}
                  ${isSelected ? 'ring-4 ring-blue-500' : ''}
                  cursor-pointer
                  hover:brightness-125
                `}
              >
                {piece && (
                  <span className="text-2xl md:text-4xl">
                    {getPieceSymbol(piece)}
                  </span>
                )}
              </div>
            );
          })
        )}
      </div>
      <div className="mt-4 text-lg">
        Current player: <span className={currentPlayer === 'white' ? 'text-white bg-black px-2' : 'text-black bg-white px-2'}>
          {currentPlayer.charAt(0).toUpperCase() + currentPlayer.slice(1)}
        </span>
      </div>
    </div>
  );
};

export default ChessBoard;