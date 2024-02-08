import React, { useEffect, useState } from 'react';
import axios from 'axios';  // Axios를 사용할 경우

const MyComponent = () => {
  const [data, setData] = useState([]);

  useEffect(() => {
    // API 요청을 보내는 함수
    const fetchData = async () => {
      try {
        // Axios를 사용할 경우
        const response = await axios.get('http://localhost:8000/api/your-endpoint/');

        // 또는 fetch를 사용할 경우
        // const response = await fetch('http://localhost:8000/api/your-endpoint/');
        // const data = await response.json();

        setData(response.data);
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };

    // fetchData 함수 호출
    fetchData();
  }, []);  // useEffect를 빈 배열로 전달하여 컴포넌트가 마운트될 때 한 번만 실행되도록 함

  return (
    <div>
      {/* 데이터를 사용하여 UI 렌더링 */}
      {data.map(item => (
        <p key={item.id}>{item.name}</p>
      ))}
    </div>
  );
};

export default MyComponent;
