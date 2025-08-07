import { request } from '@playwright/test';

export interface ApiResponse<T = any> {
  status: number;
  data: T;
  headers: Record<string, string>;
}

export interface RequestOptions {
  headers?: Record<string, string>;
  timeout?: number;
}

export class ApiClient {
  private baseUrl: string;
  private defaultOptions: RequestOptions;
  private authToken: string | null = null;

  constructor(baseUrl: string, defaultOptions: RequestOptions = {}) {
    this.baseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl;
    this.defaultOptions = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      ...defaultOptions,
    };
  }

  setAuthToken(token: string): void {
    this.authToken = token;
  }

  clearAuthToken(): void {
    this.authToken = null;
  }

  async get<T = any>(path: string, options: RequestOptions = {}): Promise<ApiResponse<T>> {
    return this.request<T>('GET', path, undefined, options);
  }

  async post<T = any>(path: string, body?: any, options: RequestOptions = {}): Promise<ApiResponse<T>> {
    return this.request<T>('POST', path, body, options);
  }

  async put<T = any>(path: string, body?: any, options: RequestOptions = {}): Promise<ApiResponse<T>> {
    return this.request<T>('PUT', path, body, options);
  }

  async patch<T = any>(path: string, body?: any, options: RequestOptions = {}): Promise<ApiResponse<T>> {
    return this.request<T>('PATCH', path, body, options);
  }

  async delete<T = any>(path: string, options: RequestOptions = {}): Promise<ApiResponse<T>> {
    return this.request<T>('DELETE', path, undefined, options);
  }

  private async request<T = any>(
    method: string,
    path: string,
    body?: any,
    options: RequestOptions = {}
  ): Promise<ApiResponse<T>> {
    const url = `${this.baseUrl}${path.startsWith('/') ? path : `/${path}`}`;
   const headers = { ...this.defaultOptions.headers, ...options.headers };

    if (this.authToken) headers['Cookie'] = `token=${this.authToken}`;

    // Create a new Playwright request context
    const context = await request.newContext({
      baseURL: this.baseUrl,
      extraHTTPHeaders: headers,
      timeout: options.timeout || this.defaultOptions.timeout,
    });

    try {
      // Make the request using Playwright
      const response = await context[method.toLowerCase() as 'get' | 'post' | 'put' | 'patch' | 'delete'](
        path.startsWith('/') ? path : `/${path}`,
        { data: body }
      );

      // Process response headers
      const responseHeaders: Record<string, string> = {};
      for (const [key, value] of Object.entries(response.headers())) {
        responseHeaders[key] = value;
      }

      // Get response data
      let data: T;
      const contentType = responseHeaders['content-type'];

      if (contentType?.includes('application/json')) {
        data = await response.json() as T;
      } else {
        const text = await response.text();
        try {
          data = JSON.parse(text) as T;
        } catch {
          data = text as unknown as T;
        }
      }

      // Dispose of the request context
      const apiResponse: ApiResponse<T> = {
        status: response.status(),
        data,
        headers: responseHeaders,
      };

      if (apiResponse.status >= 400) {
        throw new Error(
          `API Error: ${method} ${url} -> ${apiResponse.status}\n` +
          `Response: ${JSON.stringify(apiResponse.data)}`
        );
      }

      await context.dispose();
      return apiResponse;

    } catch (error) {
      console.error(`API Request Error: ${method} ${url}`, error);
      // Make sure to dispose of the context even if there's an error
      await context.dispose();
      throw error;
    }
  }
}