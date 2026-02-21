import axios from 'axios';

interface AxiosInstance extends axios.AxiosInstance {}

declare const service: AxiosInstance;

export default service;