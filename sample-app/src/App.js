import React, { useState } from 'react';
import './App.css';

function App() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedDoc, setSelectedDoc] = useState(null); // NEW: Track open document

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!query.trim()) return;

    setLoading(true);
    setTimeout(() => {
      setResults([
        { id: 1, title: 'Sample Document 1', content: 'Full text for Document 1: AWS Amplify is a set of tools and services...', score: 0.95 },
        { id: 2, title: 'Sample Document 2', content: 'Full text for Document 2: RAG stands for Retrieval-Augmented Generation...', score: 0.87 },
        { id: 3, title: 'Sample Document 3', content: 'Full text for Document 3: Vector databases are key for semantic search...', score: 0.78 }
      ]);
      setLoading(false);
    }, 800);
  };

  return (
    <div className="App">
      <header className="header">
        <div className="header-content">
          <h1>🚀 RAG Demo Live</h1> {/* CHANGE: Clear UI change for RM */}
          <p>Real-time Document Retrieval & Analysis</p>
        </div>
      </header>

      <main className="main-container">
        {/* Search Section */}
        <section className="search-section">
          <form onSubmit={handleSubmit} className="search-form">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Ask a question..."
              className="search-input"
            />
            <button type="submit" className="search-button" disabled={loading}>
              {loading ? 'Searching...' : 'Search'}
            </button>
          </form>
        </section>

        {/* Results Section */}
        {results.length > 0 && (
          <section className="results-section">
            <h2>Found {results.length} Documents</h2>
            <div className="results-container">
              {results.map((result) => (
                <div key={result.id} className="result-card">
                  <h3>{result.title}</h3>
                  <p>Relevance: {(result.score * 100).toFixed(0)}%</p>
                  {/* FIX: Add onClick here */}
                  <button className="view-button" onClick={() => setSelectedDoc(result)}>
                    View Full Document
                  </button>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* NEW: Modal Pop-up UI */}
        {selectedDoc && (
          <div className="modal-overlay">
            <div className="modal-content">
              <h2>{selectedDoc.title}</h2>
              <hr />
              <p>{selectedDoc.content}</p>
              <button className="close-button" onClick={() => setSelectedDoc(null)}>Close</button>
            </div>
          </div>
        )}
      </main>

      <footer className="footer">
        <p>Live Demo Version • Deployed via AWS Amplify</p>
      </footer>
    </div>
  );
}

export default App;
