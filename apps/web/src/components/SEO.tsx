import { useEffect } from 'react'
import { useSiteSettings } from '../hooks/useSiteSettings'

interface SEOProps {
  title?: string
  description?: string
  ogTitle?: string
  ogDescription?: string
  ogImage?: string
  ogUrl?: string
  lang?: string
}

export function SEO({
  title,
  description,
  ogTitle,
  ogDescription,
  ogImage,
  ogUrl,
  lang = 'pt'
}: SEOProps) {
  const { settings } = useSiteSettings()

  // Build dynamic values from settings or use fallbacks
  const siteName = settings?.site_name || 'Reserve Connect'
  const metaTitle = title || settings?.meta_title || siteName
  const metaDescription = description || settings?.meta_description || ''
  
  const finalOgTitle = ogTitle || metaTitle
  const finalOgDescription = ogDescription || metaDescription

  useEffect(() => {
    // Update document title
    document.title = metaTitle

    // Update or create meta description
    let metaDesc = document.querySelector('meta[name="description"]')
    if (!metaDesc) {
      metaDesc = document.createElement('meta')
      metaDesc.setAttribute('name', 'description')
      document.head.appendChild(metaDesc)
    }
    metaDesc.setAttribute('content', metaDescription)

    // Update OG tags
    const ogTags = [
      { property: 'og:title', content: finalOgTitle },
      { property: 'og:description', content: finalOgDescription },
      { property: 'og:type', content: 'website' },
      { property: 'og:locale', content: lang === 'pt' ? 'pt_BR' : lang === 'en' ? 'en_US' : 'es_ES' },
    ]

    if (ogImage) {
      ogTags.push({ property: 'og:image', content: ogImage })
    }

    if (ogUrl) {
      ogTags.push({ property: 'og:url', content: ogUrl })
    }

    ogTags.forEach(({ property, content }) => {
      let tag = document.querySelector(`meta[property="${property}"]`)
      if (!tag) {
        tag = document.createElement('meta')
        tag.setAttribute('property', property)
        document.head.appendChild(tag)
      }
      tag.setAttribute('content', content)
    })

    // Update HTML lang attribute
    document.documentElement.lang = lang

    // Cleanup function
    return () => {
      // Optional: reset to defaults on unmount
    }
  }, [metaTitle, metaDescription, finalOgTitle, finalOgDescription, ogImage, ogUrl, lang])

  return null
}

export default SEO
