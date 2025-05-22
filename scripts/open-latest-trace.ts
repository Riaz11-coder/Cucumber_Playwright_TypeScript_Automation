import fs from 'fs';
import path from 'path';
import { exec } from 'child_process';

const tracesDir = path.join(process.cwd(), 'reports', 'traces');

fs.readdir(tracesDir, (err, files) => {
  if (err) {
    console.error('Error reading traces directory:', err.message);
    process.exit(1);
  }

  const traceFiles = files
    .filter(file => file.endsWith('.zip'))
    .map(file => ({
      file,
      time: fs.statSync(path.join(tracesDir, file)).mtime.getTime()
    }))
    .sort((a, b) => b.time - a.time); // Newest first

  if (traceFiles.length === 0) {
    console.log('No trace files found.');
    return;
  }

  const latestTrace = path.join(tracesDir, traceFiles[0].file);

  console.log(`Opening trace file: ${latestTrace}`);
  exec(`npx playwright show-trace "${latestTrace}"`);
});
