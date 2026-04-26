import React, { useState } from 'react';
import './App.css';

function App() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!query.trim()) return;

    setLoading(true);
    // Simulate API call
    setTimeout(() => {
      setResults([
        {
          id: 1,
          title: 'Sample Document 1',
          excerpt: 'This is a sample document retrieved based on your query about "' + query + '"',
          score: 0.95
        },
        {
          id: 2,
          title: 'Sample Document 2',
          excerpt: 'Another relevant document containing information about "' + query + '"',
          score: 0.87
        },
        {
          id: 3,
          title: 'Sample Document 3',
          excerpt: 'Related information regarding "' + query + '" from your knowledge base',
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
                  <button className="view-button">View Full Document</button>
                </div>
              ))}
            </div>
          </section>
        )}

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
