#!/usr/bin/env coffee

> @w5/pg/APG.js > Q EXE ITER
  @w5/uridir
  @w5/req/proxy
  @w5/req/reqBin
  @w5/pool > Pool
  @w5/write
  fs > existsSync
  path > join dirname

ROOT = dirname uridir(import.meta)
IMG = join ROOT,'img'

URL = 'https://5ok.pw/'

down = (id, hash)=>

  out = [...id.toString(36)]
  end = out.slice(3).join('')
  out = out.slice(0,3)
  if end
    out.push end
  out = out.join('/')

  console.log id,id.toString(36),out
  fp = join(IMG, out+'.avif')
  if existsSync fp
    return
  url = URL+hash
  bin = await reqBin(
    url
    headers:
      origin: 'https://xxai.art' # 为了cdn缓存，删除头无效 https://community.cloudflare.com/t/how-can-i-change-the-cache-key/319487/2
  )
  write fp, bin
  return

pool = Pool 128

for await i from ITER.bot.task('hash')
  await pool down, ...i

await pool.done

process.exit()
