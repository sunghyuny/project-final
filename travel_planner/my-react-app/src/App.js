// App.js

import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Home from './pages/Main/Home.js';
import About from './components/About';
import SignupFormComponent from './pages/Accounts/signup';

const App = () => {
  return (
    <Router>
        {/* 라우트 설정 */}
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/Accounts/signup" element={<SignupFormComponent  />} />
          <Route path="/Accounts/login" element= {<login />} />
          {/* 다른 라우트들을 추가할 수 있습니다. */}
        </Routes>
    </Router>
  );
};

export default App;
