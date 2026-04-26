import React, { useState } from 'react';
import './App.css';

function App() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedDoc, setSelectedDoc] = useState(null); // Added for the popup

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!query.trim()) return;

    setLoading(true);
    setTimeout(() => {
      setResults([
        {
          id: 1,
          title: 'Sample Document 1',
          excerpt: 'This is a sample document retrieved based on your query about "' + query + '"',
          content: 'This is the FULL text for Document 1. It contains detailed analysis of AWS services.',
          score: 0.95
        },
        {
          id: 2,
          title: 'Sample Document 2',
          excerpt: 'Another relevant document containing information about "' + query + '"',
          content: 'This is the FULL text for Document 2. It explores RAG implementation patterns.',
          score: 0.87
        },
        {
          id: 3,
          title: 'Sample Document 3',
          excerpt: 'Related information regarding "' + query + '" from your knowledge base',
          content: 'This is the FULL text for Document 3. It discusses vector database optimization.',
          score: 0.78
        }
      ]);
      setLoading(false);
    }, 800);
  };

  return (
    <div className="App">
      <header className="header">
        <div className="header-content">
          <h1>🤖 RAG Agent Platform</h1>
          <p>Intelligent Document Retrieval & Analysis Demo</p>
        </div>
      </header>

      <main className="main-container">
        <section className="search-section">
          <form onSubmit={handleSubmit} className="search-form">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Ask a question about your documents..."
              className="search-input"
            />
            <button type="submit" className="search-button" disabled={loading}>
              {loading ? 'Searching...' : 'Search'}
            </button>
          </form>
        </section>

        {results.length > 0 && (
          <section className="results-section">
            <h2>Results ({results.length} documents found)</h2>
            <div className="results-container">
              {results.map((result) => (
                <div key={result.id} className="result-card">
                  <div className="result-header">
                    <h3>{result.title}</h3>
                    <span className="relevance-score">
                      Relevance: {(result.score * 100).toFixed(0)}%
                    </span>
                  </div>
                  <p className="result-excerpt">{result.excerpt}</p>
                  {/* Logic added to original button class */}
                  <button className="view-button" onClick={() => setSelectedDoc(result)}>
                    View Full Document
                  </button>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Modal Logic using original App.css classes where possible */}
        {selectedDoc && (
          <div style={{
            position: 'fixed', top: 0, left: 0, width: '100%', height: '100%',
            backgroundColor: 'rgba(0,0,0,0.8)', display: 'flex', justifyContent: 'center',
            alignItems: 'center', zIndex: 1000, padding: '20px'
          }} onClick={() => setSelectedDoc(null)}>
            <div className="result-card" style={{ maxWidth: '600px', width: '100%' }} onClick={e => e.stopPropagation()}>
              <h2>{selectedDoc.title}</h2>
              <hr style={{ margin: '15px 0' }} />
              <p style={{ color: '#333', lineHeight: '1.6' }}>{selectedDoc.content}</p>
              <button className="view-button" style={{ marginTop: '20px', background: '#eee' }} onClick={() => setSelectedDoc(null)}>
                Close Document
              </button>
            </div>
          </div>
        )}

        {/* Empty State remains original */}
        {results.length === 0 && !loading && (
          <section className="empty-state">
            <div className="empty-content">
              <h2>Welcome to RAG Agent Platform</h2>
              <p>This is a demonstration of the Retrieval-Augmented Generation system deployed on AWS.</p>
              <div className="features">
                <div className="feature-item">
                  <span className="feature-icon">📚</span>
                  <h4>Document Retrieval</h4>
                  <p>Search through your knowledge base using natural language</p>
                </div>
                <div className="feature-item">
                  <span className="feature-icon">🔍</span>
                  <h4>Semantic Search</h4>
                  <p>Find relevant documents using OpenSearch vector embeddings</p>
                </div>
                <div className="feature-item">
                  <span className="feature-icon">⚡</span>
                  <h4>Real-time Processing</h4>
                  <p>Get instant results powered by AWS infrastructure</p>
                </div>
              </div>
              <p className="try-message">Try searching for something above to get started!</p>
            </div>
          </section>
        )}
      </main>

      <footer className="footer">
        <p>RAG Agent Platform v0.1.0 • Deployed on AWS Amplify</p>
      </footer>
    </div>
  );
}

export default App;
